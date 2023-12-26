# shellcheck disable=SC2148,SC2034,SC2154

override_git_prompt_colors () {
  GIT_PROMPT_COMMAND_OK=""
  GIT_PROMPT_COMMAND_FAIL="(_LAST_COMMAND_STATE_) "
  GIT_PROMPT_THEME_NAME="Custom"
  GIT_PROMPT_START_USER="${BoldGreen}\\u${White}@${BoldYellow}\\h${ResetColor}:${Cyan}${PathShort}${ResetColor}"
  GIT_PROMPT_END_USER="\\n${White}${Time12a}${ResetColor} _LAST_COMMAND_INDICATOR_$ "
}

reload_git_prompt_colors "Custom"
