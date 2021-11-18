local rbc = {}

function copy_path()
  local file_path = vim.fn.fnamemodify(vim.fn.expand("%"), ":~:.")
  vim.fn.setreg("*", file_path)
  print("copied: " .. file_path)
end

function copy_python_path()
  local file_path = vim.fn.fnamemodify(vim.fn.expand("%"), ":~:.")
  local py_object_name = vim.fn.expand("<cword>")
  local py_import_path = string.gsub(string.gsub(file_path, ".py$", ""), "/", ".")
  local py_import_command = "from " .. py_import_path .. " import " .. py_object_name
  py_import_command = string.gsub(py_import_command, " scrapers.", " ")
  vim.fn.setreg("*", py_import_command)
  print("copied: " .. py_import_command)
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
rbc.copy_python_path = copy_python_path
rbc.build_pytest_command = build_pytest_command

return rbc