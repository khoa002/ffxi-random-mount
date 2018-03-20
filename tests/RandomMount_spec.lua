package.path = '../?.lua;../RandomMount/?.lua;./?.lua'

describe('RandomMount', function ()

    before_each(function ()
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


end)
