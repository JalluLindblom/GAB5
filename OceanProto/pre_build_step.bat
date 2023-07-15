
@echo off

if %YYconfig% == Default (
	:: Print all variables to a temporary file that can be read during runtime.
	set > %YYoutputFolder%\__build_tools_pre_build_env_vars.txt
)

exit /b 0
