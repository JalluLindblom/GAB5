
@echo off
:: This is executed just before the packaging step is run, when all files are ready and just before the final command is executed to ZIP or create the installer / prepare store ready packaging.


:: Go to the included files directory.
if "%YYPLATFORM_name%" == "HTML5" (
    cd /D %YYoutputFolder%\%YYPLATFORM_option_html5_foldername%
) else (
    cd /D %YYoutputFolder%
)

:: Remove GMLive included files from the build.
@RD /s /q "GMLive"

:: Remove the env vars file that was created in a previously run build bat.
del "__build_tools_pre_build_env_vars.txt"

exit /b 0
