local rbc = {}

function rbc.copy_path()
  local file_path = vim.fn.fnamemodify(vim.fn.expand("%"), ":~:.")
  vim.fn.setreg("*", file_path)
  print("copied:", file_path)
end

function rbc.build_test_command()
  local file_path = vim.fn.fnamemodify(vim.fn.expand("%"), ":~:.")
  local command
  if vim.fn.filereadable("package.json") == 1 then
    command = string.format("npm run test -- --watch %s", file_path)
  else
    local project_uses_coverage = (
      vim.fn.filereadable(".coveragerc") == 1 or vim.fn.filereadable(".coverage") == 1
    )
    local test_name = vim.fn.expand("<cword>")
    command = string.format(
      "pytest -x --ff %s %s -k %s",
      project_uses_coverage and "--no-cov" or "",
      file_path,
      test_name
    )
  end
  vim.fn.setreg("*", command)
  print("copied: " .. command)
end

return rbc
