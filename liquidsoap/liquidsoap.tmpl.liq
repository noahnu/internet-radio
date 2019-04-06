set("log.file", true)
set("log.file.path", "/var/log/liquidsoap/liquidsoap.log")
set("log.level", 3)
set("log.stdout", false)
set("log.unix_timestamps", true)

set("init.concurrent", false)
set("init.daemon", false)

def _loaddir(dirname) = audio_to_stereo(playlist(
  reload_mode="watch",
  if dirname == "" then "~/audiofiles" else "~/audiofiles/#{dirname}" end
)) end

def _icecast(src, mnt) = output.icecast(
  %mp3.cbr(bitrate=128),
  host="127.0.0.1",
  port={DEFAULT_PORT},
  password="{SOURCE_PASSWORD}",
  mount="#{mnt}",
  mksafe(src)
) end

def stream_dir(name, dirname) = _icecast(
  _loaddir("#{dirname}"),
  "#{name}"
) end

stream_dir("all", "")

