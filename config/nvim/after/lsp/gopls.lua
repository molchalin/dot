-- Keep machine-specific overrides out of the shared LSP configuration.
local path = vim.fn.stdpath("config") .. "/local_gopls.lua"
if vim.fn.filereadable(path) == 1 then
  return dofile(path)
end

return {}
