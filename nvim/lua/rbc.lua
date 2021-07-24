local rbc = {}

function copy_path()
  local file_path = vim.fn.fnamemodify(vim.fn.expand("%"), ":~:.")
  vim.fn.setreg("*", file_path)
  print("copied: " .. file_path)
end

function build_pytest_command()
  local project_uses_coverage = (
    vim.fn.filereadable(".coveragerc") == 1
    or vim.fn.filereadable(".coverage") == 1
  )
  local file_path = vim.fn.fnamemodify(vim.fn.expand("%"), ":~:.")
  local test_name = vim.fn.expand("<cword>")
  local command = (
    "pytest -x --ff "
    .. (project_uses_coverage and "--no-cov " or "")
    .. file_path 
    ..  " -k " .. test_name
  )
  vim.fn.setreg("*", command)
  print("copied: " .. command)
end


rbc.copy_path = copy_path
rbc.build_pytest_command = build_pytest_command

return rbc
