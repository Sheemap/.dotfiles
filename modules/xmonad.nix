{ config, pkgs, ... }:
{
    xsession.enable = true;
    xsession.windowManager.xmonad.enable = true;
    #xsession.windowManager.xmonad.config = "";
}
