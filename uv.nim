when defined(windows):
  import winlean
else:
  from posix import TAddrinfo, TSockaddr, TSockaddrIn, TSockaddrIn6, TMode, TOff, TGid

const LIBUV =
  when defined(windows): "libuv.dll"
  elif defined(macosx):  "libuv.dylib"
  else:                  "libuv.so"

{.push callConv: cdecl, dynlib: LIBUV.}
type
  TBuf* = object
    base* : cstring
    len* : int
  TFile* = cint
  TOsSock* = cint
  TOnce*    = object
  TThread*  = object
  TMutex*   = object
  TRwlock*  = object
  TSem*     = object
  TCond*    = object
  TBarrier* = object
    n* : cuint
    count* : cuint
    mutex* : TMutex
    turnstile1* : TSem
    turnstile2* : TSem

  TGid* = object
  TUid* = object
  TLib* = object
    handle* : pointer
    errmsg* : cstring

  TIoCb = proc (loop: ptr TLoop; w: ptr TIo; events: cuint) {.cdecl.}
  TIo = object
    cb : TIoCb
    pending_queue : array[0..2 - 1, pointer]
    watcher_queue : array[0..2 - 1, pointer]
    pevents : cuint
    events : cuint
    fd : cint
    rcount : cint
    wcount : cint

  TPoll* = object
    close_cb* : TCloseCb
    data* : pointer
    loop* : ptr TLoop
    ttype* : THandleType
    handle_queue* : array[0..2 - 1, pointer]
    flags* : cint
    next_closing* : ptr THandle
    poll_cb* : TPollCb
    io_watcher* : TIo

  TPollEvent* = enum
    READABLE = 1, WRITABLE = 2

  TErrCode* {.size: sizeof(cint).} = enum
    UNKNOWN = - 1, OK = 0, EOF = 1, EADDRINFO = 2, EACCES = 3, EAGAIN = 4, EADDRINUSE = 5,
    EADDRNOTAVAIL = 6, EAFNOSUPPORT = 7, EALREADY = 8, EBADF = 9, EBUSY = 10, ECONNABORTED = 11,
    ECONNREFUSED = 12, ECONNRESET = 13, EDESTADDRREQ = 14, EFAULT = 15, EHOSTUNREACH = 16,
    EINTR = 17, EINVAL = 18, EISCONN = 19, EMFILE = 20, EMSGSIZE = 21, ENETDOWN = 22,
    ENETUNREACH = 23, ENFILE = 24, ENOBUFS = 25, ENOMEM = 26, ENOTDIR = 27, EISDIR = 28,
    ENONET = 29, ENOTCONN = 31, ENOTSOCK = 32, ENOTSUP = 33, ENOENT = 34, ENOSYS = 35, EPIPE = 36,
    EPROTO = 37, EPROTONOSUPPORT = 38, EPROTOTYPE = 39, ETIMEDOUT = 40, ECHARSET = 41,
    EAIFAMNOSUPPORT = 42, EAISERVICE = 44, EAISOCKTYPE = 45, ESHUTDOWN = 46, EEXIST = 47,
    ESRCH = 48, ENAMETOOLONG = 49, EPERM = 50, ELOOP = 51, EXDEV = 52, ENOTEMPTY = 53, ENOSPC = 54,
    EIO = 55, EROFS = 56, ENODEV = 57, ESPIPE = 58, ECANCELED = 59, MAX_ERRORS
  THandleType* {.size: sizeof(cint).} = enum
    UNKNOWN_HANDLE = 0, ASYNC, CHECK, FS_EVENT, FS_POLL, HANDLE, IDLE, NAMED_PIPE, POLL, PREPARE,
    PROCESS, STREAM, TCP, TIMER, TTY, UDP, SIGNAL, FILE, HANDLE_TYPE_MAX
  TReqType* {.size: sizeof(cint).} = enum
    UNKNOWN_REQ = 0, REQ, CONNECT, WRITE, SHUTDOWN, UDP_SEND, FS, WORK, GETADDRINFO, REQ_TYPE_MAX
  TRunMode* {.size: sizeof(cint).} = enum
    RUN_DEFAULT = 0, RUN_ONCE, RUN_NOWAIT

  TShutdown* = object
    data* : pointer
    ttype* : TReqType
    active_queue* : array[0..2 - 1, pointer]
    handle* : ptr TStream
    cb* : TShutdownCb

  THandle* = object
    close_cb* : TCloseCb
    data* : pointer
    loop* : ptr TLoop
    ttype* : THandleType
    handle_queue* : array[0..2 - 1, pointer]
    flags* : cint
    next_closing* : ptr THandle

  TPipe* = object
    close_cb* : TCloseCb
    data* : pointer
    loop* : ptr TLoop
    ttype* : THandleType
    handle_queue* : array[0..2 - 1, pointer]
    flags* : cint
    next_closing* : ptr THandle
    write_queue_size* : int
    alloc_cb* : TAllocCb
    read_cb* : TReadCb
    read2_cb* : TRead2Cb
    connect_req* : ptr TConnect
    shutdown_req* : ptr TShutdown
    io_watcher* : TIo
    write_queue* : array[0..2 - 1, pointer]
    write_completed_queue* : array[0..2 - 1, pointer]
    connection_cb* : TConnectionCb
    delayed_error* : cint
    accepted_fd* : cint
    select* : pointer
    ipc* : cint
    pipe_fname* : cstring

  TTreeEntry* = object
    rbe_left* : ptr TTimer
    rbe_right* : ptr TTimer
    rbe_parent* : ptr TTimer
    rbe_color* : cint

  TTimer* = object
    close_cb* : TCloseCb
    data* : pointer
    loop* : ptr TLoop
    ttype* : THandleType
    handle_queue* : array[0..2 - 1, pointer]
    flags* : cint
    next_closing* : ptr THandle
    tree_entry* : TTreeEntry
    timer_cb* : TTimerCb
    timeout* : uint64
    repeat* : uint64
    start_id* : uint64

  TTermios* = object

  TTty* = object
    close_cb* : TCloseCb
    data* : pointer
    loop* : ptr TLoop
    ttype* : THandleType
    handle_queue* : array[0..2 - 1, pointer]
    flags* : cint
    next_closing* : ptr THandle
    write_queue_size* : int
    alloc_cb* : TAllocCb
    read_cb* : TReadCb
    read2_cb* : TRead2Cb
    connect_req* : ptr TConnect
    shutdown_req* : ptr TShutdown
    io_watcher* : TIo
    write_queue* : array[0..2 - 1, pointer]
    write_completed_queue* : array[0..2 - 1, pointer]
    connection_cb* : TConnectionCb
    delayed_error* : cint
    accepted_fd* : cint
    select* : pointer
    orig_termios* : TTermios
    mode* : cint

  TCheck* = object
    close_cb* : TCloseCb
    data* : pointer
    loop* : ptr TLoop
    ttype* : THandleType
    handle_queue* : array[0..2 - 1, pointer]
    flags* : cint
    next_closing* : ptr THandle
    check_cb* : TCheckCb
    queue* : array[0..2 - 1, pointer]

  TPrepare* = object
    close_cb* : TCloseCb
    data* : pointer
    loop* : ptr TLoop
    ttype* : THandleType
    handle_queue* : array[0..2 - 1, pointer]
    flags* : cint
    next_closing* : ptr THandle
    prepare_cb* : TPrepareCb
    queue* : array[0..2 - 1, pointer]

  TIdle* = object
    close_cb* : TCloseCb
    data* : pointer
    loop* : ptr TLoop
    ttype* : THandleType
    handle_queue* : array[0..2 - 1, pointer]
    flags* : cint
    next_closing* : ptr THandle
    idle_cb* : TIdleCb
    queue* : array[0..2 - 1, pointer]

  TAsync* = object
    close_cb* : TCloseCb
    data* : pointer
    loop* : ptr TLoop
    ttype* : THandleType
    handle_queue* : array[0..2 - 1, pointer]
    flags* : cint
    next_closing* : ptr THandle
    async_cb* : TAsyncCb
    queue* : array[0..2 - 1, pointer]
    pending* : cint


  TWorkreq* = object
    work* : proc (w: ptr TWork) {.cdecl.}
    done* : proc (w: ptr TWork; status: cint) {.cdecl.}
    loop* : ptr TLoop
    wq* : array[0..2 - 1, pointer]

  TWorkCb* = proc (req: ptr TWork) {.cdecl.}
  TWork* = object
    data* : pointer
    ttype* : TReqType
    active_queue* : array[0..2 - 1, pointer]
    loop* : ptr TLoop
    work_cb* : TWorkCb
    after_work_cb* : TAfterWorkCb
    work_req* : TWorkreq

  TGetaddrinfoCb* = proc (req: ptr TGetaddrinfo; status: cint; res: ptr TAddrinfo) {.cdecl.}
  TGetaddrinfo* = object
    data* : pointer
    ttype* : TReqType
    active_queue* : array[0..2 - 1, pointer]
    loop* : ptr TLoop
    work_req* : TWorkreq
    cb* : TGetaddrinfoCb
    hints* : ptr TAddrinfo
    hostname* : cstring
    service* : cstring
    res* : ptr TAddrinfo
    retcode* : cint

  TStdioFlags* {.size: sizeof(cint).} = enum
    IGNORE = 0x00000000, CREATE_PIPE = 0x00000001, INHERIT_FD = 0x00000002,
    INHERIT_STREAM = 0x00000004, READABLE_PIPE = 0x00000010, WRITABLE_PIPE = 0x00000020
  TDataU* = object
    stream* : ptr TStream
    fd* : cint

  TStdioContainer* = object
    flags* : TStdioFlags
    data* : TDataU

  TProcessOptions* = object
    exit_cb* : TExitCb
    file* : cstring
    args* : cstringArray
    env* : cstringArray
    cwd* : cstring
    flags* : cuint
    uid* : TUid
    gid* : TGid

  TProcessFlags* = enum
    PROCESS_SETUID = (1 shl 0), PROCESS_SETGID = (1 shl 1),
    PROCESS_WINDOWS_VERBATIM_ARGUMENTS = (1 shl 2), PROCESS_DETACHED = (1 shl 3),
    PROCESS_WINDOWS_HIDE = (1 shl 4)
  TProcess* = object
    close_cb* : TCloseCb
    data* : pointer
    loop* : ptr TLoop
    ttype* : THandleType
    handle_queue* : array[0..2 - 1, pointer]
    flags* : cint
    next_closing* : ptr THandle
    exit_cb* : TExitCb
    pid* : cint
    queue* : array[0..2 - 1, pointer]
    errorno* : cint

  TCpuTimes* = object
    user* : uint64
    nice* : uint64
    sys* : uint64
    idle* : uint64
    irq* : uint64

  TCpuInfo* = object
    model* : cstring
    speed* : cint
    cpu_times* : TCpuTimes

  TAddressU* = object
    address4* : TSockaddr_in
    address6* : TSockaddr_in6

  TNetmaskU* = object
    netmask4* : TSockaddr_in
    netmask6* : TSockaddr_in6

  TInterfaceAddress* = object
    name* : cstring
    is_internal* : cint
    address* : TAddressU
    netmask* : TNetmaskU

  TFsType* {.size: sizeof(cint).} = enum
    FS_UNKNOWN = - 1, FS_CUSTOM, FS_OPEN, FS_CLOSE, FS_READ, FS_WRITE, FS_SENDFILE, FS_STAT,
    FS_LSTAT, FS_FSTAT, FS_FTRUNCATE, FS_UTIME, FS_FUTIME, FS_CHMOD, FS_FCHMOD, FS_FSYNC,
    FS_FDATASYNC, FS_UNLINK, FS_RMDIR, FS_MKDIR, FS_RENAME, FS_READDIR, FS_LINK, FS_SYMLINK,
    FS_READLINK, FS_CHOWN, FS_FCHOWN
  TFs* = object
    data* : pointer
    ttype* : TReqType
    active_queue* : array[0..2 - 1, pointer]
    fs_type* : TFsType
    loop* : ptr TLoop
    cb* : TFsCb
    result* : int
    pptr* : pointer
    path* : cstring
    errorno* : TErrCode
    statbuf* : TStat
    new_path* : cstring
    file* : TFile
    flags* : cint
    mode* : TMode
    buf* : pointer
    len* : int
    off* : TOff
    uid* : TUid
    gid* : TGid
    atime* : cdouble
    mtime* : cdouble
    work_req* : TWorkreq

  EFsEvent* = enum
    RENAME = 1, CHANGE = 2
  TFsEvent* = object
    close_cb* : TCloseCb
    data* : pointer
    loop* : ptr TLoop
    ttype* : THandleType
    handle_queue* : array[0..2 - 1, pointer]
    flags* : cint
    next_closing* : ptr THandle
    filename* : cstring
    cb* : TFsEventCb
    event_watcher* : TIo
    realpath* : cstring
    realpath_len* : cint
    cf_flags* : cint
    cf_eventstream* : pointer
    cf_cb* : ptr TAsync
    cf_events* : array[0..2 - 1, pointer]
    cf_sem* : TSem
    cf_mutex* : TMutex

  TFsPoll* = object
    close_cb* : TCloseCb
    data* : pointer
    loop* : ptr TLoop
    ttype* : THandleType
    handle_queue* : array[0..2 - 1, pointer]
    flags* : cint
    next_closing* : ptr THandle
    poll_ctx* : pointer

  TFsEventFlags* = enum
    FS_EVENT_WATCH_ENTRY = 1, FS_EVENT_STAT = 2, FS_EVENT_RECURSIVE = 3

  TSignal* = object
    close_cb* : TCloseCb
    data* : pointer
    loop* : ptr TLoop
    ttype* : THandleType
    handle_queue* : array[0..2 - 1, pointer]
    flags* : cint
    next_closing* : ptr THandle
    signal_cb* : TSignalCb
    signum* : cint
    tree_entry* : TTreeEntry
    caught_signals* : cuint
    dispatched_signals* : cuint

  TAnyHandle* = object
    async* : TAsync
    check* : TCheck
    fs_event* : EFsEvent
    fs_poll* : TFsPoll
    handle* : THandle
    idle* : TIdle
    pipe* : TPipe
    poll* : TPoll
    prepare* : TPrepare
    process* : TProcess
    stream* : TStream
    tcp* : TTcp
    timer* : TTimer
    tty* : TTty
    udp* : TUdp
    signal* : TSignal

  TAnyReq* = object
    req* : TReq
    connect* : TConnect
    write* : TWrite
    shutdown* : TShutdown
    udp_send* : TUdpSend
    fs* : TFs
    work* : TWork
    getaddrinfo* : TGetaddrinfo

  TTimers* = object
    rbh_root* : ptr TTimer

  TLoop* = object
    data* : pointer
    last_err* : TErr
    active_handles* : cuint
    handle_queue* : array[0..2 - 1, pointer]
    active_reqs* : array[0..2 - 1, pointer]
    stop_flag* : cuint
    flags* : culong
    backend_fd* : cint
    pending_queue* : array[0..2 - 1, pointer]
    watcher_queue* : array[0..2 - 1, pointer]
    watchers* : ptr ptr TIo
    nwatchers* : cuint
    nfds* : cuint
    wq* : array[0..2 - 1, pointer]
    wq_mutex* : TMutex
    wq_async* : TAsync
    closing_handles* : ptr THandle
    process_handles* : array[0..2 - 1, array[0..1 - 1, pointer]]
    prepare_handles* : array[0..2 - 1, pointer]
    check_handles* : array[0..2 - 1, pointer]
    idle_handles* : array[0..2 - 1, pointer]
    async_handles* : array[0..2 - 1, pointer]
    async_watcher* : TAsync
    timer_handles* : TTimers
    time* : uint64
    signal_pipefd* : array[0..2 - 1, cint]
    signal_io_watcher* : TIo
    child_watcher* : TSignal
    emfile_fd* : cint
    timer_counter* : uint64
    cf_thread* : TThread
    cf_cb* : pointer
    cf_loop* : pointer
    cf_mutex* : TMutex
    cf_sem* : TSem
    cf_signals* : array[0..2 - 1, pointer]

  TCallback* = proc () {.cdecl.}
  TEntry* = proc (arg: pointer) {.cdecl.}
  TAllocCb* = proc (handle: ptr THandle; suggested_size: int): TBuf {.cdecl.}
  TReadCb* = proc (stream: ptr TStream; nread: int; buf: TBuf) {.cdecl.}
  TRead2Cb* = proc (pipe: ptr TPipe; nread: int; buf: TBuf; pending: THandleType) {.cdecl.}
  TWriteCb* = proc (req: ptr TWrite; status: cint) {.cdecl.}
  TConnectCb* = proc (req: ptr TConnect; status: cint) {.cdecl.}
  TShutdownCb* = proc (req: ptr TShutdown; status: cint) {.cdecl.}
  TConnectionCb* = proc (server: ptr TStream; status: cint) {.cdecl.}
  TCloseCb* = proc (handle: ptr THandle) {.cdecl.}
  TPollCb* = proc (handle: ptr TPoll; status: cint; events: cint) {.cdecl.}
  TTimerCb* = proc (handle: ptr TTimer; status: cint) {.cdecl.}
  TAsyncCb* = proc (handle: ptr TAsync; status: cint) {.cdecl.}
  TPrepareCb* = proc (handle: ptr TPrepare; status: cint) {.cdecl.}
  TCheckCb* = proc (handle: ptr TCheck; status: cint) {.cdecl.}
  TIdleCb* = proc (handle: ptr TIdle; status: cint) {.cdecl.}
  TExitCb* = proc (a2: ptr TProcess; exit_status: cint; term_signal: cint) {.cdecl.}
  TWalkCb* = proc (handle: ptr THandle; arg: pointer) {.cdecl.}
  TFsCb* = proc (req: ptr TFs) {.cdecl.}
  TAfterWorkCb* = proc (req: ptr TWork; status: cint) {.cdecl.}
  TTimespec* = object
    tv_sec* : clong
    tv_nsec* : clong

  TStat* = object
    st_dev* : uint64
    st_mode* : uint64
    st_nlink* : uint64
    st_uid* : uint64
    st_gid* : uint64
    st_rdev* : uint64
    st_ino* : uint64
    st_size* : uint64
    st_blksize* : uint64
    st_blocks* : uint64
    st_atim* : TTimespec
    st_mtim* : TTimespec
    st_ctim* : TTimespec

  TFsEventCb* = proc (handle: ptr TFsEvent; filename: cstring; events: cint; status: cint) {.cdecl.}
  TFsPollCb* = proc (handle: ptr TFsPoll; status: cint; prev: ptr TStat; curr: ptr TStat) {.cdecl.}
  TSignalCb* = proc (handle: ptr TSignal; signum: cint) {.cdecl.}
  TMembership* {.size: sizeof(cint).} = enum
    LEAVE_GROUP = 0, JOIN_GROUP
  TErr* = object
    code* : TErrCode
    sys_errno* : cint

  TReq* = object
    data* : pointer
    ttype* : TReqType
    active_queue* : array[0..2 - 1, pointer]

  TStream* = object
    close_cb* : TCloseCb
    data* : pointer
    loop* : ptr TLoop
    ttype* : THandleType
    handle_queue* : array[0..2 - 1, pointer]
    flags* : cint
    next_closing* : ptr THandle
    write_queue_size* : int
    alloc_cb* : TAllocCb
    read_cb* : TReadCb
    read2_cb* : TRead2Cb
    connect_req* : ptr TConnect
    shutdown_req* : ptr TShutdown
    io_watcher* : TIo
    write_queue* : array[0..2 - 1, pointer]
    write_completed_queue* : array[0..2 - 1, pointer]
    connection_cb* : TConnectionCb
    delayed_error* : cint
    accepted_fd* : cint
    select* : pointer

  TWrite* = object
    data* : pointer
    ttype* : TReqType
    active_queue* : array[0..2 - 1, pointer]
    cb* : TWriteCb
    send_handle* : ptr TStream
    handle* : ptr TStream
    queue* : array[0..2 - 1, pointer]
    write_index* : cint
    bufs* : ptr TBuf
    bufcnt* : cint
    error* : cint
    bufsml* : array[0..4 - 1, TBuf]

  TTcp* = object
    close_cb* : TCloseCb
    data* : pointer
    loop* : ptr TLoop
    ttype* : THandleType
    handle_queue* : array[0..2 - 1, pointer]
    flags* : cint
    next_closing* : ptr THandle
    write_queue_size* : int
    alloc_cb* : TAllocCb
    read_cb* : TReadCb
    read2_cb* : TRead2Cb
    connect_req* : ptr TConnect
    shutdown_req* : ptr TShutdown
    io_watcher* : TIo
    write_queue* : array[0..2 - 1, pointer]
    write_completed_queue* : array[0..2 - 1, pointer]
    connection_cb* : TConnectionCb
    delayed_error* : cint
    accepted_fd* : cint
    select* : pointer

  TConnect* = object
    data* : pointer
    ttype* : TReqType
    active_queue* : array[0..2 - 1, pointer]
    cb* : TConnectCb
    handle* : ptr TStream
    queue* : array[0..2 - 1, pointer]

  TUdpFlags* = enum
    UDP_IPV6ONLY = 1, UDP_PARTIAL = 2
  TUdpSendCb* = proc (req: ptr TUdpSend; status: cint) {.cdecl.}
  TUdpRecvCb* = proc (handle: ptr TUdp; nread: int; buf: TBuf; adr: ptr TSockaddr; flags: cuint) {.cdecl.}
  TUdp* = object
    close_cb* : TCloseCb
    data* : pointer
    loop* : ptr TLoop
    ttype* : THandleType
    handle_queue* : array[0..2 - 1, pointer]
    flags* : cint
    next_closing* : ptr THandle
    alloc_cb* : TAllocCb
    recv_cb* : TUdpRecvCb
    io_watcher* : TIo
    write_queue* : array[0..2 - 1, pointer]
    write_completed_queue* : array[0..2 - 1, pointer]

  TUdpSend* = object
    data* : pointer
    ttype* : TReqType
    active_queue* : array[0..2 - 1, pointer]
    handle* : ptr TUdp
    cb* : TUdpSendCb
    queue* : array[0..2 - 1, pointer]
    adr* : TSockaddr_in6
    bufcnt* : cint
    bufs* : ptr TBuf
    status* : int
    send_cb* : TUdpSendCb
    bufsml* : array[0..4 - 1, TBuf]

proc uv_version*(): cuint {.importc.}
proc uv_version_string*(): cstring {.importc.}
proc uv_loop_new*(): ptr TLoop {.importc.}
proc uv_loop_delete*(a2: ptr TLoop) {.importc.}
proc uv_default_loop*(): ptr TLoop {.importc.}
proc uv_run*(a2: ptr TLoop; mode: TRunMode): cint {.importc.}
proc uv_stop*(a2: ptr TLoop) {.importc.}
proc uv_ref*(a2: ptr THandle) {.importc.}
proc uv_unref*(a2: ptr THandle) {.importc.}
# proc uv_has_ref*(a2: ptr THandle): cint {.importc.}
proc uv_update_time*(a2: ptr TLoop) {.importc.}
proc uv_now*(a2: ptr TLoop): uint64 {.importc.}
proc uv_backend_fd*(a2: ptr TLoop): cint {.importc.}
proc uv_backend_timeout*(a2: ptr TLoop): cint {.importc.}
proc uv_last_error*(a2: ptr TLoop): TErr {.importc.}
proc uv_strerror*(err: TErr): cstring {.importc.}
proc uv_err_name*(err: TErr): cstring {.importc.}
proc uv_shutdown(req: ptr TShutdown; handle: ptr TStream; cb: TShutdownCb): cint {.importc.}
proc uv_handle_size*(ttype: THandleType): int {.importc.}
proc uv_req_size*(ttype: TReqType): int {.importc.}
proc uv_is_active*(handle: ptr THandle): cint {.importc.}
proc uv_walk*(loop: ptr TLoop; walk_cb: TWalkCb; arg: pointer) {.importc.}
proc uv_close*(handle: ptr THandle; close_cb: TCloseCb) {.importc.}
proc uv_buf_init*(base: cstring; len: cuint): TBuf {.importc.}
proc uv_strlcpy*(dst: cstring; src: cstring; size: int): int {.importc.}
proc uv_strlcat*(dst: cstring; src: cstring; size: int): int {.importc.}
proc uv_listen*(stream: ptr TStream; backlog: cint; cb: TConnectionCb): cint {.importc.}
proc uv_accept*(server: ptr TStream; client: ptr TStream): cint {.importc.}
proc uv_read_start*(a2: ptr TStream; alloc_cb: TAllocCb; read_cb: TReadCb): cint {.importc.}
proc uv_read_stop*(a2: ptr TStream): cint {.importc.}
proc uv_read2_start*(a2: ptr TStream; alloc_cb: TAllocCb; read_cb: TRead2Cb): cint {.importc.}
proc uv_write(req: ptr TWrite; handle: ptr TStream; bufs: ptr TBuf; bufcnt: cint; cb: TWriteCb): cint {.importc.}
proc uv_write2*(req: ptr TWrite; handle: ptr TStream; bufs: ptr TBuf; bufcnt: cint;
                send_handle: ptr TStream; cb: TWriteCb): cint {.importc.}
proc uv_is_readable*(handle: ptr TStream): cint {.importc.}
proc uv_is_writable*(handle: ptr TStream): cint {.importc.}
# proc uv_stream_set_blocking*(handle: ptr TStream; blocking: cint): cint {.importc.}
proc uv_is_closing*(handle: ptr THandle): cint {.importc.}
proc uv_tcp_init*(a2: ptr TLoop; handle: ptr TTcp): cint {.importc.}
proc uv_tcp_open*(handle: ptr TTcp; sock: TOsSock): cint {.importc.}
proc uv_tcp_nodelay*(handle: ptr TTcp; enable: cint): cint {.importc.}
proc uv_tcp_keepalive*(handle: ptr TTcp; enable: cint; delay: cuint): cint {.importc.}
proc uv_tcp_simultaneous_accepts*(handle: ptr TTcp; enable: cint): cint {.importc.}
proc uv_tcp_bind*(handle: ptr TTcp; a3: TSockaddr_in): cint {.importc.}
proc uv_tcp_bind6*(handle: ptr TTcp; a3: TSockaddr_in6): cint {.importc.}
proc uv_tcp_getsockname*(handle: ptr TTcp; name: ptr TSockaddr; namelen: ptr cint): cint {.importc.}
proc uv_tcp_getpeername*(handle: ptr TTcp; name: ptr TSockaddr; namelen: ptr cint): cint {.importc.}
proc uv_tcp_connect*(req: ptr TConnect; handle: ptr TTcp; address: TSockaddr_in; cb: TConnectCb): cint {.importc.}
proc uv_tcp_connect6*(req: ptr TConnect; handle: ptr TTcp; address: TSockaddr_in6; cb: TConnectCb): cint {.importc.}
proc uv_udp_init*(a2: ptr TLoop; handle: ptr TUdp): cint {.importc.}
proc uv_udp_open*(handle: ptr TUdp; sock: TOsSock): cint {.importc.}
proc uv_udp_bind*(handle: ptr TUdp; adr: TSockaddr_in; flags: cuint): cint {.importc.}
proc uv_udp_bind6*(handle: ptr TUdp; adr: TSockaddr_in6; flags: cuint): cint {.importc.}
proc uv_udp_getsockname*(handle: ptr TUdp; name: ptr TSockaddr; namelen: ptr cint): cint {.importc.}
proc uv_udp_set_membership*(handle: ptr TUdp; multicast_addr: cstring; interface_addr: cstring;
                            membership: TMembership): cint {.importc.}
proc uv_udp_set_multicast_loop*(handle: ptr TUdp; on: cint): cint {.importc.}
proc uv_udp_set_multicast_ttl*(handle: ptr TUdp; ttl: cint): cint {.importc.}
proc uv_udp_set_broadcast*(handle: ptr TUdp; on: cint): cint {.importc.}
proc uv_udp_set_ttl*(handle: ptr TUdp; ttl: cint): cint {.importc.}
proc uv_udp_send(req: ptr TUdpSend; handle: ptr TUdp; bufs: ptr TBuf; bufcnt: cint; adr: TSockaddr_in;
                 send_cb: TUdpSendCb): cint {.importc.}
proc uv_udp_send6*(req: ptr TUdpSend; handle: ptr TUdp; bufs: ptr TBuf; bufcnt: cint;
                   adr: TSockaddr_in6; send_cb: TUdpSendCb): cint {.importc.}
proc uv_udp_recv_start*(handle: ptr TUdp; alloc_cb: TAllocCb; recv_cb: TUdpRecvCb): cint {.importc.}
proc uv_udp_recv_stop*(handle: ptr TUdp): cint {.importc.}
proc uv_tty_init*(a2: ptr TLoop; a3: ptr TTty; fd: TFile; readable: cint): cint {.importc.}
proc uv_tty_set_mode*(a2: ptr TTty; mode: cint): cint {.importc.}
proc uv_tty_reset_mode*() {.importc.}
proc uv_tty_get_winsize*(a2: ptr TTty; width: ptr cint; height: ptr cint): cint {.importc.}
proc uv_guess_handle*(file: TFile): THandleType {.importc.}
proc uv_pipe_init*(a2: ptr TLoop; handle: ptr TPipe; ipc: cint): cint {.importc.}
proc uv_pipe_open*(a2: ptr TPipe; file: TFile): cint {.importc.}
proc uv_pipe_bind*(handle: ptr TPipe; name: cstring): cint {.importc.}
proc uv_pipe_connect*(req: ptr TConnect; handle: ptr TPipe; name: cstring; cb: TConnectCb) {.importc.}
proc uv_pipe_pending_instances*(handle: ptr TPipe; count: cint) {.importc.}
proc uv_poll_init*(loop: ptr TLoop; handle: ptr TPoll; fd: cint): cint {.importc.}
proc uv_poll_init_socket*(loop: ptr TLoop; handle: ptr TPoll; socket: TOsSock): cint {.importc.}
proc uv_poll_start*(handle: ptr TPoll; events: cint; cb: TPollCb): cint {.importc.}
proc uv_poll_stop*(handle: ptr TPoll): cint {.importc.}
proc uv_prepare_init*(a2: ptr TLoop; prepare: ptr TPrepare): cint {.importc.}
proc uv_prepare_start*(prepare: ptr TPrepare; cb: TPrepareCb): cint {.importc.}
proc uv_prepare_stop*(prepare: ptr TPrepare): cint {.importc.}
proc uv_check_init*(a2: ptr TLoop; check: ptr TCheck): cint {.importc.}
proc uv_check_start*(check: ptr TCheck; cb: TCheckCb): cint {.importc.}
proc uv_check_stop*(check: ptr TCheck): cint {.importc.}
proc uv_idle_init*(a2: ptr TLoop; idle: ptr TIdle): cint {.importc.}
proc uv_idle_start*(idle: ptr TIdle; cb: TIdleCb): cint {.importc.}
proc uv_idle_stop*(idle: ptr TIdle): cint {.importc.}
proc uv_async_init*(a2: ptr TLoop; async: ptr TAsync; async_cb: TAsyncCb): cint {.importc.}
proc uv_async_send*(async: ptr TAsync): cint {.importc.}
proc uv_timer_init*(a2: ptr TLoop; handle: ptr TTimer): cint {.importc.}
proc uv_timer_start*(handle: ptr TTimer; cb: TTimerCb; timeout: uint64; repeat: uint64): cint {.importc.}
proc uv_timer_stop*(handle: ptr TTimer): cint {.importc.}
proc uv_timer_again*(handle: ptr TTimer): cint {.importc.}
proc uv_timer_set_repeat*(handle: ptr TTimer; repeat: uint64) {.importc.}
proc uv_timer_get_repeat*(handle: ptr TTimer): uint64 {.importc.}
proc uv_getaddrinfo(loop: ptr TLoop; req: ptr TGetaddrinfo; getaddrinfo_cb: TGetaddrinfoCb;
                    node: cstring; service: cstring; hints: ptr TAddrinfo): cint {.importc.}
proc uv_freeaddrinfo*(ai: ptr TAddrinfo) {.importc.}
proc uv_spawn*(a2: ptr TLoop; a3: ptr TProcess; options: TProcessOptions): cint {.importc.}
proc uv_process_kill*(a2: ptr TProcess; signum: cint): cint {.importc.}
proc uv_kill*(pid: cint; signum: cint): TErr {.importc.}
proc uv_queue_work*(loop: ptr TLoop; req: ptr TWork; work_cb: TWorkCb; after_work_cb: TAfterWorkCb): cint {.importc.}
proc uv_cancel*(req: ptr TReq): cint {.importc.}
proc uv_setup_args*(argc: cint; argv: cstringArray): cstringArray {.importc.}
proc uv_get_process_title*(buffer: cstring; size: int): TErr {.importc.}
proc uv_set_process_title*(title: cstring): TErr {.importc.}
proc uv_resident_set_memory*(rss: ptr int): TErr {.importc.}
proc uv_uptime*(uptime: ptr cdouble): TErr {.importc.}
proc uv_cpu_info*(cpu_infos: ptr ptr TCpuInfo; count: ptr cint): TErr {.importc.}
proc uv_free_cpu_info*(cpu_infos: ptr TCpuInfo; count: cint) {.importc.}
proc uv_interface_addresses*(addresses: ptr ptr TInterfaceAddress; count: ptr cint): TErr {.importc.}
proc uv_free_interface_addresses*(addresses: ptr TInterfaceAddress; count: cint) {.importc.}
proc uv_fs_req_cleanup*(req: ptr TFs) {.importc.}
proc uv_fs_close*(loop: ptr TLoop; req: ptr TFs; file: TFile; cb: TFsCb): cint {.importc.}
proc uv_fs_open*(loop: ptr TLoop; req: ptr TFs; path: cstring; flags: cint; mode: cint; cb: TFsCb): cint {.importc.}
proc uv_fs_read*(loop: ptr TLoop; req: ptr TFs; file: TFile; buf: pointer; length: int; offset: int64;
                 cb: TFsCb): cint {.importc.}
proc uv_fs_unlink*(loop: ptr TLoop; req: ptr TFs; path: cstring; cb: TFsCb): cint {.importc.}
proc uv_fs_write*(loop: ptr TLoop; req: ptr TFs; file: TFile; buf: pointer; length: int;
                  offset: int64; cb: TFsCb): cint {.importc.}
proc uv_fs_mkdir*(loop: ptr TLoop; req: ptr TFs; path: cstring; mode: cint; cb: TFsCb): cint {.importc.}
proc uv_fs_rmdir*(loop: ptr TLoop; req: ptr TFs; path: cstring; cb: TFsCb): cint {.importc.}
proc uv_fs_readdir*(loop: ptr TLoop; req: ptr TFs; path: cstring; flags: cint; cb: TFsCb): cint {.importc.}
proc uv_fs_stat*(loop: ptr TLoop; req: ptr TFs; path: cstring; cb: TFsCb): cint {.importc.}
proc uv_fs_fstat*(loop: ptr TLoop; req: ptr TFs; file: TFile; cb: TFsCb): cint {.importc.}
proc uv_fs_rename*(loop: ptr TLoop; req: ptr TFs; path: cstring; new_path: cstring; cb: TFsCb): cint {.importc.}
proc uv_fs_fsync*(loop: ptr TLoop; req: ptr TFs; file: TFile; cb: TFsCb): cint {.importc.}
proc uv_fs_fdatasync*(loop: ptr TLoop; req: ptr TFs; file: TFile; cb: TFsCb): cint {.importc.}
proc uv_fs_ftruncate*(loop: ptr TLoop; req: ptr TFs; file: TFile; offset: int64; cb: TFsCb): cint {.importc.}
proc uv_fs_sendfile*(loop: ptr TLoop; req: ptr TFs; out_fd: TFile; in_fd: TFile; in_offset: int64;
                     length: int; cb: TFsCb): cint {.importc.}
proc uv_fs_chmod*(loop: ptr TLoop; req: ptr TFs; path: cstring; mode: cint; cb: TFsCb): cint {.importc.}
proc uv_fs_utime*(loop: ptr TLoop; req: ptr TFs; path: cstring; atime: cdouble; mtime: cdouble;
                  cb: TFsCb): cint {.importc.}
proc uv_fs_futime*(loop: ptr TLoop; req: ptr TFs; file: TFile; atime: cdouble; mtime: cdouble;
                   cb: TFsCb): cint {.importc.}
proc uv_fs_lstat*(loop: ptr TLoop; req: ptr TFs; path: cstring; cb: TFsCb): cint {.importc.}
proc uv_fs_link*(loop: ptr TLoop; req: ptr TFs; path: cstring; new_path: cstring; cb: TFsCb): cint {.importc.}
proc uv_fs_symlink*(loop: ptr TLoop; req: ptr TFs; path: cstring; new_path: cstring; flags: cint;
                    cb: TFsCb): cint {.importc.}
proc uv_fs_readlink*(loop: ptr TLoop; req: ptr TFs; path: cstring; cb: TFsCb): cint {.importc.}
proc uv_fs_fchmod*(loop: ptr TLoop; req: ptr TFs; file: TFile; mode: cint; cb: TFsCb): cint {.importc.}
proc uv_fs_chown*(loop: ptr TLoop; req: ptr TFs; path: cstring; uid: cint; gid: cint; cb: TFsCb): cint {.importc.}
proc uv_fs_fchown*(loop: ptr TLoop; req: ptr TFs; file: TFile; uid: cint; gid: cint; cb: TFsCb): cint {.importc.}
proc uv_fs_poll_init*(loop: ptr TLoop; handle: ptr TFsPoll): cint {.importc.}
proc uv_fs_poll_start*(handle: ptr TFsPoll; poll_cb: TFsPollCb; path: cstring; interval: cuint): cint {.importc.}
proc uv_fs_poll_stop*(handle: ptr TFsPoll): cint {.importc.}
proc uv_signal_init*(loop: ptr TLoop; handle: ptr TSignal): cint {.importc.}
proc uv_signal_start*(handle: ptr TSignal; signal_cb: TSignalCb; signum: cint): cint {.importc.}
proc uv_signal_stop*(handle: ptr TSignal): cint {.importc.}
proc uv_loadavg*(avg: array[0..3 - 1, cdouble]) {.importc.}
proc uv_fs_event_init*(loop: ptr TLoop; handle: ptr TFsEvent; filename: cstring; cb: TFsEventCb; flags: cint): cint {.importc.}
proc uv_ip4_addr*(ip: cstring; port: cint): TSockaddrIn {.importc.}
proc uv_ip6_addr*(ip: cstring; port: cint): TSockaddrIn6 {.importc.}
proc uv_ip4_name*(src: ptr TSockaddrIn; dst: cstring; size: int): cint {.importc.}
proc uv_ip6_name*(src: ptr TSockaddrIn6; dst: cstring; size: int): cint {.importc.}
proc uv_inet_ntop*(af: cint; src: pointer; dst: cstring; size: int): TErr {.importc.}
proc uv_inet_pton*(af: cint; src: cstring; dst: pointer): TErr {.importc.}
proc uv_exepath*(buffer: cstring; size: ptr int): cint {.importc.}
proc uv_cwd*(buffer: cstring; size: int): TErr {.importc.}
proc uv_chdir*(dir: cstring): TErr {.importc.}
proc uv_get_free_memory*(): uint64 {.importc.}
proc uv_get_total_memory*(): uint64 {.importc.}
proc uv_hrtime*(): uint64 {.importc.}
proc uv_disable_stdio_inheritance*() {.importc.}
proc uv_dlopen*(filename: cstring; lib: ptr TLib): cint {.importc.}
proc uv_dlclose*(lib: ptr TLib) {.importc.}
proc uv_dlsym*(lib: ptr TLib; name: cstring; p: ptr pointer): cint {.importc.}
proc uv_dlerror*(lib: ptr TLib): cstring {.importc.}
proc uv_mutex_init*(handle: ptr TMutex): cint {.importc.}
proc uv_mutex_destroy*(handle: ptr TMutex) {.importc.}
proc uv_mutex_lock*(handle: ptr TMutex) {.importc.}
proc uv_mutex_trylock*(handle: ptr TMutex): cint {.importc.}
proc uv_mutex_unlock*(handle: ptr TMutex) {.importc.}
proc uv_rwlock_init*(rwlock: ptr TRwlock): cint {.importc.}
proc uv_rwlock_destroy*(rwlock: ptr TRwlock) {.importc.}
proc uv_rwlock_rdlock*(rwlock: ptr TRwlock) {.importc.}
proc uv_rwlock_tryrdlock*(rwlock: ptr TRwlock): cint {.importc.}
proc uv_rwlock_rdunlock*(rwlock: ptr TRwlock) {.importc.}
proc uv_rwlock_wrlock*(rwlock: ptr TRwlock) {.importc.}
proc uv_rwlock_trywrlock*(rwlock: ptr TRwlock): cint {.importc.}
proc uv_rwlock_wrunlock*(rwlock: ptr TRwlock) {.importc.}
proc uv_sem_init*(sem: ptr TSem; value: cuint): cint {.importc.}
proc uv_sem_destroy*(sem: ptr TSem) {.importc.}
proc uv_sem_post*(sem: ptr TSem) {.importc.}
proc uv_sem_wait*(sem: ptr TSem) {.importc.}
proc uv_sem_trywait*(sem: ptr TSem): cint {.importc.}
proc uv_cond_init*(cond: ptr TCond): cint {.importc.}
proc uv_cond_destroy*(cond: ptr TCond) {.importc.}
proc uv_cond_signal*(cond: ptr TCond) {.importc.}
proc uv_cond_broadcast*(cond: ptr TCond) {.importc.}
proc uv_cond_wait*(cond: ptr TCond; mutex: ptr TMutex) {.importc.}
proc uv_cond_timedwait*(cond: ptr TCond; mutex: ptr TMutex; timeout: uint64): cint {.importc.}
proc uv_barrier_init*(barrier: ptr TBarrier; count: cuint): cint {.importc.}
proc uv_barrier_destroy*(barrier: ptr TBarrier) {.importc.}
proc uv_barrier_wait*(barrier: ptr TBarrier) {.importc.}
proc uv_once*(guard: ptr TOnce; callback: TCallback) {.importc.}
proc uv_thread_create*(tid: ptr TThread; entry: TEntry; arg: pointer): cint {.importc.}
proc uv_thread_self*(): culong {.importc.}
proc uv_thread_join*(tid: ptr TThread): cint {.importc.}
{.pop.}