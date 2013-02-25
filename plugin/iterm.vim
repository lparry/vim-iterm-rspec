" Defines helpers to run shell commands in the current iTerm terminal.

" Don't try to load if we don't have Ruby support.
if !has("ruby")
  finish
endif

command! Spec :ruby ITerm.spec
command! Cuke :ruby ITerm.cuke

ruby <<EOF

module ITerm
  def self.cuke
    current_file = VIM::Buffer.current.name
    exec("clear")
    exec("bundle exec cucumber #{current_file}")
  end

  def self.spec
    current_file = VIM::Buffer.current.name
    exec("clear")
    exec("bundle exec rspec #{current_file}")
  end

  def self.exec(command)
    osascript <<-EOF
      tell application "iTerm"
        try
          set mySession to the current session of the current terminal
        on error
          set myTerminal to (make new terminal)
          tell myTerminal
            launch session "Default"
            set mySession to the current session
          end tell
        end try
        tell mySession to write text "#{command}"
      end tell
    EOF
  end

private

  def self.osascript(script)
    system("osascript", "-e", script)
  end

end

EOF

