local MainHub, super = Class(Map)

function MainHub:onEnter()
    super.onEnter(self)
    if DTRANS then
        Game.world:startCutscene("darkenter")
        --local transition = Kristal.Stage:getObjects(LoadingDarkTransition)[1]
        --transition.resuming = true
    end
end

return MainHub