-- pandoc/filters/table-headers-autocenter.lua
-- Automatically center and bold Markdown table headers in LaTeX,
-- regardless of the column alignment set in Markdown (:---, :---:, ---:).

local function format_header_cell(cell)
  if not cell.contents or #cell.contents == 0 then
    return
  end

  local first_block = cell.contents[1]
  if first_block.t == 'Plain' or first_block.t == 'Para' then
    local inlines = first_block.content
    local new_inlines = {}
    local has_multicol = false

    for _, inl in ipairs(inlines) do
      if inl.t == 'RawInline' and inl.text:match('\\multicolumn') then
        has_multicol = true
      end
    end

    if not has_multicol then
      table.insert(new_inlines, pandoc.RawInline('latex', '\\multicolumn{1}{c}{\\textbf{'))
      for _, inl in ipairs(inlines) do
        table.insert(new_inlines, inl)
      end
      table.insert(new_inlines, pandoc.RawInline('latex', '}}'))
      first_block.content = new_inlines
    end
  end
end

function Table(tbl)
  if not FORMAT:match('latex') then
    return tbl
  end

  if not tbl.head or not tbl.head.rows then
    return tbl
  end

  for _, row in ipairs(tbl.head.rows) do
    for _, cell in ipairs(row.cells) do
      format_header_cell(cell)
    end
  end

  return tbl
end
