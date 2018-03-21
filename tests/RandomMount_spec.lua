package.path = '../?.lua;../RandomMount/?.lua;../mocks/?.lua;./?.lua'

describe('RandomMount', function ()

    local events
    local owned_key_items

    _G.windower = {
        register_event = function (event, func)
            events[event] = func
        end,
        ffxi = {
            get_key_items = function ()
                return owned_key_items
            end
        }
    }

    before_each(function ()
        package.loaded['resources'] = nil
        _G._addon = {}
        events = {}
        owned_key_items = {}
    end)

    local get_script = function ()
        package.loaded['RandomMount'] = nil
        return require('RandomMount')
    end

    it('sets the addon name to "RandomMount"', function ()

        get_script()

        assert.is.equal('RandomMount', _G._addon.name)
    end)

    it('sets the addon author to "Xurion of Bismarck"', function ()

        get_script()

        assert.is.equal('Xurion of Bismarck', _G._addon.author)
    end)

    it('sets the addon version in the format of "x.y.z"', function ()

        get_script()

        assert.is.equal(false, string.match(_G._addon.version, "%d+%.%d+%.%d+") == nil)
    end)

    it('sets a single addon command of "rm"', function ()

        get_script()

        assert.is.equal(1, #_G._addon.commands)
        assert.is.equal('rm', _G._addon.commands[1])
    end)

    it('sets an empty owned_kis table property', function ()

        local script = get_script()

        assert.is.same({}, script.owned_kis)
    end)

    it('sets an empty owned_mounts table property', function ()

        local script = get_script()

        assert.is.same({}, script.owned_mounts)
    end)

    describe('get_mount_kis_from_resources()', function ()

        it('returns an empty table if there are no mounts in the key items resource', function ()

            local resources = require('resources')
            resources.key_items = {
                [0] = {id = 0, en = "Mock key item", category = "Not a mount"},
                [1] = {id = 1, en = "Another mock key item", category = "Not a mount either"},
            }

            local script = get_script()

            assert.is.same({}, script.get_mount_kis_from_resources())
        end)

        it('returns a table of mount names taken from the key items resource', function ()

            local resources = require('resources')
            resources.key_items = {
                [0] = {id = 0, en = "Mock key item", category = "Not a mount"},
                [1] = {id = 1, en = "♪Mock mount", category = "Mounts"},
                [2] = {id = 2, en = "Another mock key item", category = "Not a mount either"},
            }

            local script = get_script()

            assert.is.same({[1] = '♪Mock mount'}, script.get_mount_kis_from_resources())
        end)
    end)

    it('updates the owned_kis property to all player key items on time change event', function ()

        local script = get_script()
        script.owned_kis = {}
        owned_key_items = {
            [1] = 1337
        }

        events['time change']()

        assert.is.same({1337}, script.owned_kis)
    end)

    it('adds new key items to the owned_kis property on time change event', function ()

        local script = get_script()
        script.owned_kis = {}
        events['time change']()

        owned_key_items = {
            [1] = 1337
        }
        events['time change']()

        assert.is.same({1337}, script.owned_kis)
    end)

    it("does not change the owned_kis property on time change event if the player's key item count is less than the previous update to owned_kis", function ()

        local script = get_script()
        script.owned_kis = {1337}
        owned_key_items = {}

        events['time change']()

        assert.is.same({1337}, script.owned_kis)
    end)

    it('sets the random number seed to the operating system time', function ()

        math.randomseed(os.time())
    end)
end)
