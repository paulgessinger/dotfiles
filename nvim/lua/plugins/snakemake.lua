return {
  "snakemake/snakemake",
  config = function(plugin)
    vim.opt.rtp:append(plugin.dir .. "/misc/vim")
  end,
  lazy = false,
  ft = "snakemake",
}
