module Log extend self

    def d(tag, message)
        log(Log::DEBUG, tag, message)
    end

    def w(tag, message)
        log(Log::WARNING, tag, message)
    end

    def e(tag, message)
        log(Log::ERROR, tag, message)
    end

    def i(tag, message)
        log(Log::INFO, tag, message)
    end

    def v(tag, message)
        log(Log::VERBOSE, tag, message)
    end

    def wtf(tag, message)
        log(Log::WTF, tag, message)
    end

    def add(key,value)
        @hash ||= Hash.new(nil)
        @hash[key] = value
    end

    def const_missing(key)
        @hash[key]
    end

    def each
        @hash.each { |key,value|
            yield(key,value)
        }
    end

    Log.add(:DEBUG, "DEBUG")
    Log.add(:WARNING, "WARNING")
    Log.add(:ERROR, "ERROR")
    Log.add(:INFO, "INFO")
    Log.add(:VERBOSE, "VERBOSE")
    Log.add(:GLOBAL, "GLOBAL")
    Log.add(:WTF, "WTF")

    def log(level, tag, message)
        thread = Thread.new {
            tag = "[#{tag}]"
            currTime = Time.new.to_i
            yearMonthDayTime = Time.at(currTime).strftime("%Y-%m-%d")
            hourMinuteSecondTime = Time.at(currTime).strftime("%H:%M:%S,%L")
            @logPath = File.expand_path("~/.ascenge/")
            @logDir = Dir.mkdir(@logPath) unless File.exists?(@logPath)
            # Prints out in format of: 2015-12-03 - 12:37:16.000 - INFO - Ascenge - Initializing World...
            output = "#{yearMonthDayTime.ljust(11)}- #{hourMinuteSecondTime.ljust(13)}- #{level.ljust(level.length + 1)}- #{tag.ljust(tag.length + 1)}- #{message}\n"
            File.open(@logPath + "/#{level.downcase}.log", 'a') { |file| file.write(output) }
            File.open(@logPath + "/global.log", 'a') { |file| file.write(output) }
        }
        thread.join
    end

    def global(tag, message)
        thread = Thread.new {
            level = Log::GLOBAL
            tag = "[#{tag}]"
            currTime = Time.new.to_i
            yearMonthDayTime = Time.at(currTime).strftime("%Y-%m-%d")
            hourMinuteSecondTime = Time.at(currTime).strftime("%H:%M:%S,%L")
            @logPath = File.expand_path("~/.ascenge/")
            @logDir = Dir.mkdir(@logPath) unless File.exists?(@logPath)
            output = "#{yearMonthDayTime.ljust(11)}- #{hourMinuteSecondTime.ljust(13)}- #{level.ljust(level.length + 1)}- #{tag.ljust(tag.length + 1)}- #{message}\n"
            Log.each { |key,value|
                File.open(@logPath + "/#{value.downcase}.log", 'a') { |file| file.write(output) }
            }
        }
        thread.join
    end

    alias :debug :d
    alias :warning :w
    alias :error :e
    alias :info :i
    alias :verbose :v
    private :log

end
