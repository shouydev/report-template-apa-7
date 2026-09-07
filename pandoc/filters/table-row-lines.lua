-- pandoc/filters/table-row-lines.lua
-- Automatically insert horizontal rules (\midrule) between body rows in Markdown tables.

function Table(tbl)
  if not FORMAT:match('latex') then
    return tbl
  end

  local doc = pandoc.Pandoc({tbl})
  local latex = pandoc.write(doc, 'latex')

  -- The longtable body starts after \endlastfoot (or \endhead) and ends before \end{longtable}
  local before_body, body, after_body = latex:match('^(.-)(\\endlastfoot.-)(\\end{longtable}.-)$')
  if not body then
    before_body, body, after_body = latex:match('^(.-)(\\endhead.-)(\\end{longtable}.-)$')
  end

  if body then
    local start_marker = body:match('^(\\endlastfoot\r?\n?)') or body:match('^(\\endhead\r?\n?)')
    local rest = body:sub(#start_marker + 1)

    local lines = {}
    for line in rest:gmatch('([^\r\n]*)') do
      table.insert(lines, line)
    end

    -- Identify rows that end with \\ or \tabularnewline
    local row_indices = {}
    for i, line in ipairs(lines) do
      if line:match('\\\\%s*$') or line:match('\\tabularnewline%s*$') then
        table.insert(row_indices, i)
      end
    end

    -- Add \midrule\noalign{} to every row except the last
    for k = 1, #row_indices - 1 do
      local idx = row_indices[k]
      lines[idx] = lines[idx]:gsub('(\\\\%s*)$', '\\\\ \\midrule\\noalign{}'):gsub('(\\tabularnewline%s*)$', '\\tabularnewline \\midrule\\noalign{}')
    end

    local new_body = start_marker .. table.concat(lines, '\n')
    return pandoc.RawBlock('latex', before_body .. new_body .. after_body)
  end

  return tbl
end