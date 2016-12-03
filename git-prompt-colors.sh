override_git_prompt_colors () {
  GIT_PROMPT_THEME_NAME="Custom"
  GIT_PROMPT_START_USER="${BoldGreen}\\u${White}@${BoldYellow}\\h${ResetColor}:${Cyan}${PathShort}${ResetColor}"
  GIT_PROMPT_END_USER="\n${White}${Time12a}${ResetColor} $ "
}

reload_git_prompt_colors "Custom"
