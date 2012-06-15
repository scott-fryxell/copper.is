$diary_out ||= File.open('./log/diary','w+')

class Object
  def __entry(line, io = ($diary_out || $stdout))
    c = caller[1].sub(Rails.root.to_s,'').split(':in').first
    io.puts ".#{c} #{line}"
    io.flush
  end
  
  def _entry(line='')
    __entry line.inspect if Rails.env.test?
  end

  def _last_entry(line='')
    if Rails.env.test?
      __entry line.inspect
      exit 1
    end
  end
end
