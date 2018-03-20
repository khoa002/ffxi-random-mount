package.path = '../?.lua;../RandomMount/?.lua;../mocks/?.lua;./?.lua'

describe('RandomMount', function ()

    before_each(function ()
        package.loaded['resources'] = nil
        _G._addon = {}
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

            local mock_mount = {id = 1, en = "A mock mount", category = "Mounts"}
            local resources = require('resources')
            resources.key_items = {
                [0] = {id = 0, en = "Mock key item", category = "Not a mount"},
                [1] = mock_mount,
                [2] = {id = 2, en = "Another mock key item", category = "Not a mount either"},
            }

            local script = get_script()

            assert.is.same({[1] = 'A mock mount'}, script.get_mount_kis_from_resources())
        end)
    end)
end)
