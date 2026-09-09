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
    local has_centering = false
    local has_bfseries = false

    for _, inl in ipairs(inlines) do
      if inl.t == 'RawInline' then
        if inl.text:match('\\centering') then
          has_centering = true
        end
        if inl.text:match('\\bfseries') then
          has_bfseries = true
        end
      end
      table.insert(new_inlines, inl)
    end

    -- Inject \centering and \bfseries at the start of the header if they are not already present
    if not has_centering and not has_bfseries then
      table.insert(new_inlines, 1, pandoc.RawInline('latex', '\\centering\\bfseries '))
    elseif not has_centering then
      table.insert(new_inlines, 1, pandoc.RawInline('latex', '\\centering '))
    elseif not has_bfseries then
      table.insert(new_inlines, 1, pandoc.RawInline('latex', '\\bfseries '))
    end

    first_block.content = new_inlines
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