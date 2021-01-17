################################################################################
#  THIS FILE IS 100% GENERATED BY ZPROJECT; DO NOT EDIT EXCEPT EXPERIMENTALLY  #
#  Read the zproject/README.md for information about making permanent changes. #
################################################################################

module CZMQ
  module FFI

    #
    # @note This class is 100% generated using zproject.
    class Zsys
      # Raised when one tries to use an instance of {Zsys} after
      # the internal pointer to the native object has been nullified.
      class DestroyedError < RuntimeError; end

      # Boilerplate for self pointer, initializer, and finalizer
      class << self
        alias :__new :new
      end
      # Attaches the pointer _ptr_ to this instance and defines a finalizer for
      # it if necessary.
      # @param ptr [::FFI::Pointer]
      # @param finalize [Boolean]
      def initialize(ptr, finalize = true)
        @ptr = ptr
        if @ptr.null?
          @ptr = nil # Remove null pointers so we don't have to test for them.
        elsif finalize
          @finalizer = self.class.create_finalizer_for @ptr
          ObjectSpace.define_finalizer self, @finalizer
        end
      end
      # @return [Proc]
      def self.create_finalizer_for(ptr)
        Proc.new do
          "WARNING: "\
          "Objects of type #{self} cannot be destroyed implicitly. "\
          "Please call the correct destroy method with the relevant arguments."
        end
      end
      # @return [Boolean]
      def null?
        !@ptr or @ptr.null?
      end
      # Return internal pointer
      # @return [::FFI::Pointer]
      def __ptr
        raise DestroyedError unless @ptr
        @ptr
      end
      # So external Libraries can just pass the Object to a FFI function which expects a :pointer
      alias_method :to_ptr, :__ptr
      # Nullify internal pointer and return pointer pointer.
      # @note This detaches the current instance from the native object
      #   and thus makes it unusable.
      # @return [::FFI::MemoryPointer] the pointer pointing to a pointer
      #   pointing to the native object
      def __ptr_give_ref
        raise DestroyedError unless @ptr
        ptr_ptr = ::FFI::MemoryPointer.new :pointer
        ptr_ptr.write_pointer @ptr
        __undef_finalizer if @finalizer
        @ptr = nil
        ptr_ptr
      end
      # Undefines the finalizer for this object.
      # @note Only use this if you need to and can guarantee that the native
      #   object will be freed by other means.
      # @return [void]
      def __undef_finalizer
        ObjectSpace.undefine_finalizer self
        @finalizer = nil
      end

      # Create a new callback of the following type:
      # Callback for interrupt signal handler
      #     typedef void (zsys_handler_fn) (
      #         int signal_value);
      #
      # @note WARNING: If your Ruby code doesn't retain a reference to the
      #   FFI::Function object after passing it to a C function call,
      #   it may be garbage collected while C still holds the pointer,
      #   potentially resulting in a segmentation fault.
      def self.handler_fn
        ::FFI::Function.new :void, [:int], blocking: true do |signal_value|
          result = yield signal_value
          result
        end
      end

      # Initialize CZMQ zsys layer; this happens automatically when you create
      # a socket or an actor; however this call lets you force initialization
      # earlier, so e.g. logging is properly set-up before you start working.
      # Not threadsafe, so call only from main thread. Safe to call multiple
      # times. Returns global CZMQ context.
      #
      # @return [::FFI::Pointer]
      def self.init()
        result = ::CZMQ::FFI.zsys_init()
        result
      end

      # Optionally shut down the CZMQ zsys layer; this normally happens automatically
      # when the process exits; however this call lets you force a shutdown
      # earlier, avoiding any potential problems with atexit() ordering, especially
      # with Windows dlls.
      #
      # @return [void]
      def self.shutdown()
        result = ::CZMQ::FFI.zsys_shutdown()
        result
      end

      # Get a new ZMQ socket, automagically creating a ZMQ context if this is
      # the first time. Caller is responsible for destroying the ZMQ socket
      # before process exits, to avoid a ZMQ deadlock. Note: you should not use
      # this method in CZMQ apps, use zsock_new() instead.
      # *** This is for CZMQ internal use only and may change arbitrarily ***
      #
      # @param type [Integer, #to_int, #to_i]
      # @param filename [String, #to_s, nil]
      # @param line_nbr [Integer, #to_int, #to_i]
      # @return [::FFI::Pointer]
      def self.socket(type, filename, line_nbr)
        type = Integer(type)
        line_nbr = Integer(line_nbr)
        result = ::CZMQ::FFI.zsys_socket(type, filename, line_nbr)
        result
      end

      # Destroy/close a ZMQ socket. You should call this for every socket you
      # create using zsys_socket().
      # *** This is for CZMQ internal use only and may change arbitrarily ***
      #
      # @param handle [::FFI::Pointer, #to_ptr]
      # @param filename [String, #to_s, nil]
      # @param line_nbr [Integer, #to_int, #to_i]
      # @return [Integer]
      def self.close(handle, filename, line_nbr)
        line_nbr = Integer(line_nbr)
        result = ::CZMQ::FFI.zsys_close(handle, filename, line_nbr)
        result
      end

      # Return ZMQ socket name for socket type
      # *** This is for CZMQ internal use only and may change arbitrarily ***
      #
      # @param socktype [Integer, #to_int, #to_i]
      # @return [::FFI::Pointer]
      def self.sockname(socktype)
        socktype = Integer(socktype)
        result = ::CZMQ::FFI.zsys_sockname(socktype)
        result
      end

      # Create a pipe, which consists of two PAIR sockets connected over inproc.
      # The pipe is configured to use the zsys_pipehwm setting. Returns the
      # frontend socket successful, NULL if failed.
      #
      # @param backend_p [#__ptr_give_ref]
      # @return [Zsock]
      def self.create_pipe(backend_p)
        backend_p = backend_p.__ptr_give_ref
        result = ::CZMQ::FFI.zsys_create_pipe(backend_p)
        result = Zsock.__new result, false
        result
      end

      # Set interrupt handler; this saves the default handlers so that a
      # zsys_handler_reset () can restore them. If you call this multiple times
      # then the last handler will take affect. If handler_fn is NULL, disables
      # default SIGINT/SIGTERM handling in CZMQ.
      #
      # @param handler_fn [::FFI::Pointer, #to_ptr]
      # @return [void]
      def self.handler_set(handler_fn)
        result = ::CZMQ::FFI.zsys_handler_set(handler_fn)
        result
      end

      # Reset interrupt handler, call this at exit if needed
      #
      # @return [void]
      def self.handler_reset()
        result = ::CZMQ::FFI.zsys_handler_reset()
        result
      end

      # Set default interrupt handler, so Ctrl-C or SIGTERM will set
      # zsys_interrupted. Idempotent; safe to call multiple times.
      # Can be suppressed by ZSYS_SIGHANDLER=false
      # *** This is for CZMQ internal use only and may change arbitrarily ***
      #
      # @return [void]
      def self.catch_interrupts()
        result = ::CZMQ::FFI.zsys_catch_interrupts()
        result
      end

      # Check if default interrupt handler of Ctrl-C or SIGTERM was called.
      # Does not work if ZSYS_SIGHANDLER is false and code does not call
      # set interrupted on signal.
      #
      # @return [Boolean]
      def self.is_interrupted()
        result = ::CZMQ::FFI.zsys_is_interrupted()
        result
      end

      # Set interrupted flag. This is done by default signal handler, however
      # this can be handy for language bindings or cases without default
      # signal handler.
      #
      # @return [void]
      def self.set_interrupted()
        result = ::CZMQ::FFI.zsys_set_interrupted()
        result
      end

      # Return 1 if file exists, else zero
      #
      # @param filename [String, #to_s, nil]
      # @return [Boolean]
      def self.file_exists(filename)
        result = ::CZMQ::FFI.zsys_file_exists(filename)
        result
      end

      # Return file modification time. Returns 0 if the file does not exist.
      #
      # @param filename [String, #to_s, nil]
      # @return [::FFI::Pointer]
      def self.file_modified(filename)
        result = ::CZMQ::FFI.zsys_file_modified(filename)
        result
      end

      # Return file mode; provides at least support for the POSIX S_ISREG(m)
      # and S_ISDIR(m) macros and the S_IRUSR and S_IWUSR bits, on all boxes.
      # Returns a mode_t cast to int, or -1 in case of error.
      #
      # @param filename [String, #to_s, nil]
      # @return [Integer]
      def self.file_mode(filename)
        result = ::CZMQ::FFI.zsys_file_mode(filename)
        result
      end

      # Delete file. Does not complain if the file is absent
      #
      # @param filename [String, #to_s, nil]
      # @return [Integer]
      def self.file_delete(filename)
        result = ::CZMQ::FFI.zsys_file_delete(filename)
        result
      end

      # Check if file is 'stable'
      #
      # @param filename [String, #to_s, nil]
      # @return [Boolean]
      def self.file_stable(filename)
        result = ::CZMQ::FFI.zsys_file_stable(filename)
        result
      end

      # Create a file path if it doesn't exist. The file path is treated as
      # printf format.
      #
      # @param pathname [String, #to_s, nil]
      # @param args [Array<Object>] see https://github.com/ffi/ffi/wiki/examples#using-varargs
      # @return [Integer]
      def self.dir_create(pathname, *args)
        result = ::CZMQ::FFI.zsys_dir_create(pathname, *args)
        result
      end

      # Remove a file path if empty; the pathname is treated as printf format.
      #
      # @param pathname [String, #to_s, nil]
      # @param args [Array<Object>] see https://github.com/ffi/ffi/wiki/examples#using-varargs
      # @return [Integer]
      def self.dir_delete(pathname, *args)
        result = ::CZMQ::FFI.zsys_dir_delete(pathname, *args)
        result
      end

      # Move to a specified working directory. Returns 0 if OK, -1 if this failed.
      #
      # @param pathname [String, #to_s, nil]
      # @return [Integer]
      def self.dir_change(pathname)
        result = ::CZMQ::FFI.zsys_dir_change(pathname)
        result
      end

      # Set private file creation mode; all files created from here will be
      # readable/writable by the owner only.
      #
      # @return [void]
      def self.file_mode_private()
        result = ::CZMQ::FFI.zsys_file_mode_private()
        result
      end

      # Reset default file creation mode; all files created from here will use
      # process file mode defaults.
      #
      # @return [void]
      def self.file_mode_default()
        result = ::CZMQ::FFI.zsys_file_mode_default()
        result
      end

      # Return the CZMQ version for run-time API detection; returns version
      # number into provided fields, providing reference isn't null in each case.
      #
      # @param major [::FFI::Pointer, #to_ptr]
      # @param minor [::FFI::Pointer, #to_ptr]
      # @param patch [::FFI::Pointer, #to_ptr]
      # @return [void]
      def self.version(major, minor, patch)
        result = ::CZMQ::FFI.zsys_version(major, minor, patch)
        result
      end

      # Format a string using printf formatting, returning a freshly allocated
      # buffer. If there was insufficient memory, returns NULL. Free the returned
      # string using zstr_free(). The hinted version allows one to optimize by using
      # a larger starting buffer size (known to/assumed by the developer) and so
      # avoid reallocations.
      #
      # @param hint [Integer, #to_int, #to_i]
      # @param format [String, #to_s, nil]
      # @param args [Array<Object>] see https://github.com/ffi/ffi/wiki/examples#using-varargs
      # @return [::FFI::Pointer]
      def self.sprintf_hint(hint, format, *args)
        hint = Integer(hint)
        result = ::CZMQ::FFI.zsys_sprintf_hint(hint, format, *args)
        result
      end

      # Format a string using printf formatting, returning a freshly allocated
      # buffer. If there was insufficient memory, returns NULL. Free the returned
      # string using zstr_free().
      #
      # @param format [String, #to_s, nil]
      # @param args [Array<Object>] see https://github.com/ffi/ffi/wiki/examples#using-varargs
      # @return [::FFI::Pointer]
      def self.sprintf(format, *args)
        result = ::CZMQ::FFI.zsys_sprintf(format, *args)
        result
      end

      # Format a string with a va_list argument, returning a freshly allocated
      # buffer. If there was insufficient memory, returns NULL. Free the returned
      # string using zstr_free().
      #
      # @param format [String, #to_s, nil]
      # @param argptr [::FFI::Pointer, #to_ptr]
      # @return [::FFI::Pointer]
      def self.vprintf(format, argptr)
        result = ::CZMQ::FFI.zsys_vprintf(format, argptr)
        result
      end

      # Create UDP beacon socket; if the routable option is true, uses
      # multicast (not yet implemented), else uses broadcast. This method
      # and related ones might _eventually_ be moved to a zudp class.
      # *** This is for CZMQ internal use only and may change arbitrarily ***
      #
      # @param routable [Boolean]
      # @return [Integer or FFI::Pointer]
      def self.udp_new(routable)
        routable = !(0==routable||!routable) # boolean
        result = ::CZMQ::FFI.zsys_udp_new(routable)
        result
      end

      # Close a UDP socket
      # *** This is for CZMQ internal use only and may change arbitrarily ***
      #
      # @param handle [Integer or FFI::Pointer]
      # @return [Integer]
      def self.udp_close(handle)
        result = ::CZMQ::FFI.zsys_udp_close(handle)
        result
      end

      # Send zframe to UDP socket, return -1 if sending failed due to
      # interface having disappeared (happens easily with WiFi)
      # *** This is for CZMQ internal use only and may change arbitrarily ***
      #
      # @param udpsock [Integer or FFI::Pointer]
      # @param frame [Zframe, #__ptr]
      # @param address [::FFI::Pointer, #to_ptr]
      # @param addrlen [Integer, #to_int, #to_i]
      # @return [Integer]
      def self.udp_send(udpsock, frame, address, addrlen)
        frame = frame.__ptr if frame
        addrlen = Integer(addrlen)
        result = ::CZMQ::FFI.zsys_udp_send(udpsock, frame, address, addrlen)
        result
      end

      # Receive zframe from UDP socket, and set address of peer that sent it
      # The peername must be a char [INET_ADDRSTRLEN] array if IPv6 is disabled or
      # NI_MAXHOST if it's enabled. Returns NULL when failing to get peer address.
      # *** This is for CZMQ internal use only and may change arbitrarily ***
      #
      # @param udpsock [Integer or FFI::Pointer]
      # @param peername [::FFI::Pointer, #to_ptr]
      # @param peerlen [Integer, #to_int, #to_i]
      # @return [Zframe]
      def self.udp_recv(udpsock, peername, peerlen)
        peerlen = Integer(peerlen)
        result = ::CZMQ::FFI.zsys_udp_recv(udpsock, peername, peerlen)
        result = Zframe.__new result, false
        result
      end

      # Handle an I/O error on some socket operation; will report and die on
      # fatal errors, and continue silently on "try again" errors.
      # *** This is for CZMQ internal use only and may change arbitrarily ***
      #
      # @param reason [String, #to_s, nil]
      # @return [void]
      def self.socket_error(reason)
        result = ::CZMQ::FFI.zsys_socket_error(reason)
        result
      end

      # Return current host name, for use in public tcp:// endpoints. Caller gets
      # a freshly allocated string, should free it using zstr_free(). If the host
      # name is not resolvable, returns NULL.
      #
      # @return [::FFI::Pointer]
      def self.hostname()
        result = ::CZMQ::FFI.zsys_hostname()
        result
      end

      # Move the current process into the background. The precise effect depends
      # on the operating system. On POSIX boxes, moves to a specified working
      # directory (if specified), closes all file handles, reopens stdin, stdout,
      # and stderr to the null device, and sets the process to ignore SIGHUP. On
      # Windows, does nothing. Returns 0 if OK, -1 if there was an error.
      #
      # @param workdir [String, #to_s, nil]
      # @return [Integer]
      def self.daemonize(workdir)
        result = ::CZMQ::FFI.zsys_daemonize(workdir)
        result
      end

      # Drop the process ID into the lockfile, with exclusive lock, and switch
      # the process to the specified group and/or user. Any of the arguments
      # may be null, indicating a no-op. Returns 0 on success, -1 on failure.
      # Note if you combine this with zsys_daemonize, run after, not before
      # that method, or the lockfile will hold the wrong process ID.
      #
      # @param lockfile [String, #to_s, nil]
      # @param group [String, #to_s, nil]
      # @param user [String, #to_s, nil]
      # @return [Integer]
      def self.run_as(lockfile, group, user)
        result = ::CZMQ::FFI.zsys_run_as(lockfile, group, user)
        result
      end

      # Returns true if the underlying libzmq supports CURVE security.
      # Uses a heuristic probe according to the version of libzmq being used.
      #
      # @return [Boolean]
      def self.has_curve()
        result = ::CZMQ::FFI.zsys_has_curve()
        result
      end

      # Configure the number of I/O threads that ZeroMQ will use. A good
      # rule of thumb is one thread per gigabit of traffic in or out. The
      # default is 1, sufficient for most applications. If the environment
      # variable ZSYS_IO_THREADS is defined, that provides the default.
      # Note that this method is valid only before any socket is created.
      #
      # @param io_threads [Integer, #to_int, #to_i]
      # @return [void]
      def self.set_io_threads(io_threads)
        io_threads = Integer(io_threads)
        result = ::CZMQ::FFI.zsys_set_io_threads(io_threads)
        result
      end

      # Configure the scheduling policy of the ZMQ context thread pool.
      # Not available on Windows. See the sched_setscheduler man page or sched.h
      # for more information. If the environment variable ZSYS_THREAD_SCHED_POLICY
      # is defined, that provides the default.
      # Note that this method is valid only before any socket is created.
      #
      # @param policy [Integer, #to_int, #to_i]
      # @return [void]
      def self.set_thread_sched_policy(policy)
        policy = Integer(policy)
        result = ::CZMQ::FFI.zsys_set_thread_sched_policy(policy)
        result
      end

      # Configure the scheduling priority of the ZMQ context thread pool.
      # Not available on Windows. See the sched_setscheduler man page or sched.h
      # for more information. If the environment variable ZSYS_THREAD_PRIORITY is
      # defined, that provides the default.
      # Note that this method is valid only before any socket is created.
      #
      # @param priority [Integer, #to_int, #to_i]
      # @return [void]
      def self.set_thread_priority(priority)
        priority = Integer(priority)
        result = ::CZMQ::FFI.zsys_set_thread_priority(priority)
        result
      end

      # Configure the numeric prefix to each thread created for the internal
      # context's thread pool. This option is only supported on Linux.
      # If the environment variable ZSYS_THREAD_NAME_PREFIX is defined, that
      # provides the default.
      # Note that this method is valid only before any socket is created.
      #
      # @param prefix [Integer, #to_int, #to_i]
      # @return [void]
      def self.set_thread_name_prefix(prefix)
        prefix = Integer(prefix)
        result = ::CZMQ::FFI.zsys_set_thread_name_prefix(prefix)
        result
      end

      # Return thread name prefix.
      #
      # @return [Integer]
      def self.thread_name_prefix()
        result = ::CZMQ::FFI.zsys_thread_name_prefix()
        result
      end

      # Configure the numeric prefix to each thread created for the internal
      # context's thread pool. This option is only supported on Linux.
      # If the environment variable ZSYS_THREAD_NAME_PREFIX_STR is defined, that
      # provides the default.
      # Note that this method is valid only before any socket is created.
      #
      # @param prefix [String, #to_s, nil]
      # @return [void]
      def self.set_thread_name_prefix_str(prefix)
        result = ::CZMQ::FFI.zsys_set_thread_name_prefix_str(prefix)
        result
      end

      # Return thread name prefix.
      #
      # @return [String]
      def self.thread_name_prefix_str()
        result = ::CZMQ::FFI.zsys_thread_name_prefix_str()
        result
      end

      # Adds a specific CPU to the affinity list of the ZMQ context thread pool.
      # This option is only supported on Linux.
      # Note that this method is valid only before any socket is created.
      #
      # @param cpu [Integer, #to_int, #to_i]
      # @return [void]
      def self.thread_affinity_cpu_add(cpu)
        cpu = Integer(cpu)
        result = ::CZMQ::FFI.zsys_thread_affinity_cpu_add(cpu)
        result
      end

      # Removes a specific CPU to the affinity list of the ZMQ context thread pool.
      # This option is only supported on Linux.
      # Note that this method is valid only before any socket is created.
      #
      # @param cpu [Integer, #to_int, #to_i]
      # @return [void]
      def self.thread_affinity_cpu_remove(cpu)
        cpu = Integer(cpu)
        result = ::CZMQ::FFI.zsys_thread_affinity_cpu_remove(cpu)
        result
      end

      # Configure the number of sockets that ZeroMQ will allow. The default
      # is 1024. The actual limit depends on the system, and you can query it
      # by using zsys_socket_limit (). A value of zero means "maximum".
      # Note that this method is valid only before any socket is created.
      #
      # @param max_sockets [Integer, #to_int, #to_i]
      # @return [void]
      def self.set_max_sockets(max_sockets)
        max_sockets = Integer(max_sockets)
        result = ::CZMQ::FFI.zsys_set_max_sockets(max_sockets)
        result
      end

      # Return maximum number of ZeroMQ sockets that the system will support.
      #
      # @return [Integer]
      def self.socket_limit()
        result = ::CZMQ::FFI.zsys_socket_limit()
        result
      end

      # Configure the maximum allowed size of a message sent.
      # The default is INT_MAX.
      #
      # @param max_msgsz [Integer, #to_int, #to_i]
      # @return [void]
      def self.set_max_msgsz(max_msgsz)
        max_msgsz = Integer(max_msgsz)
        result = ::CZMQ::FFI.zsys_set_max_msgsz(max_msgsz)
        result
      end

      # Return maximum message size.
      #
      # @return [Integer]
      def self.max_msgsz()
        result = ::CZMQ::FFI.zsys_max_msgsz()
        result
      end

      # Configure whether to use zero copy strategy in libzmq. If the environment
      # variable ZSYS_ZERO_COPY_RECV is defined, that provides the default.
      # Otherwise the default is 1.
      #
      # @param zero_copy [Integer, #to_int, #to_i]
      # @return [void]
      def self.set_zero_copy_recv(zero_copy)
        zero_copy = Integer(zero_copy)
        result = ::CZMQ::FFI.zsys_set_zero_copy_recv(zero_copy)
        result
      end

      # Return ZMQ_ZERO_COPY_RECV option.
      #
      # @return [Integer]
      def self.zero_copy_recv()
        result = ::CZMQ::FFI.zsys_zero_copy_recv()
        result
      end

      # Configure the threshold value of filesystem object age per st_mtime
      # that should elapse until we consider that object "stable" at the
      # current zclock_time() moment.
      # The default is S_DEFAULT_ZSYS_FILE_STABLE_AGE_MSEC defined in zsys.c
      # which generally depends on host OS, with fallback value of 5000.
      #
      # @param file_stable_age_msec [::FFI::Pointer, #to_ptr]
      # @return [void]
      def self.set_file_stable_age_msec(file_stable_age_msec)
        result = ::CZMQ::FFI.zsys_set_file_stable_age_msec(file_stable_age_msec)
        result
      end

      # Return current threshold value of file stable age in msec.
      # This can be used in code that chooses to wait for this timeout
      # before testing if a filesystem object is "stable" or not.
      #
      # @return [::FFI::Pointer]
      def self.file_stable_age_msec()
        result = ::CZMQ::FFI.zsys_file_stable_age_msec()
        result
      end

      # Configure the default linger timeout in msecs for new zsock instances.
      # You can also set this separately on each zsock_t instance. The default
      # linger time is zero, i.e. any pending messages will be dropped. If the
      # environment variable ZSYS_LINGER is defined, that provides the default.
      # Note that process exit will typically be delayed by the linger time.
      #
      # @param linger [Integer, #to_int, #to_i]
      # @return [void]
      def self.set_linger(linger)
        linger = Integer(linger)
        result = ::CZMQ::FFI.zsys_set_linger(linger)
        result
      end

      # Configure the default outgoing pipe limit (HWM) for new zsock instances.
      # You can also set this separately on each zsock_t instance. The default
      # HWM is 1,000, on all versions of ZeroMQ. If the environment variable
      # ZSYS_SNDHWM is defined, that provides the default. Note that a value of
      # zero means no limit, i.e. infinite memory consumption.
      #
      # @param sndhwm [Integer, #to_int, #to_i]
      # @return [void]
      def self.set_sndhwm(sndhwm)
        sndhwm = Integer(sndhwm)
        result = ::CZMQ::FFI.zsys_set_sndhwm(sndhwm)
        result
      end

      # Configure the default incoming pipe limit (HWM) for new zsock instances.
      # You can also set this separately on each zsock_t instance. The default
      # HWM is 1,000, on all versions of ZeroMQ. If the environment variable
      # ZSYS_RCVHWM is defined, that provides the default. Note that a value of
      # zero means no limit, i.e. infinite memory consumption.
      #
      # @param rcvhwm [Integer, #to_int, #to_i]
      # @return [void]
      def self.set_rcvhwm(rcvhwm)
        rcvhwm = Integer(rcvhwm)
        result = ::CZMQ::FFI.zsys_set_rcvhwm(rcvhwm)
        result
      end

      # Configure the default HWM for zactor internal pipes; this is set on both
      # ends of the pipe, for outgoing messages only (sndhwm). The default HWM is
      # 1,000, on all versions of ZeroMQ. If the environment var ZSYS_ACTORHWM is
      # defined, that provides the default. Note that a value of zero means no
      # limit, i.e. infinite memory consumption.
      #
      # @param pipehwm [Integer, #to_int, #to_i]
      # @return [void]
      def self.set_pipehwm(pipehwm)
        pipehwm = Integer(pipehwm)
        result = ::CZMQ::FFI.zsys_set_pipehwm(pipehwm)
        result
      end

      # Return the HWM for zactor internal pipes.
      #
      # @return [Integer]
      def self.pipehwm()
        result = ::CZMQ::FFI.zsys_pipehwm()
        result
      end

      # Configure use of IPv6 for new zsock instances. By default sockets accept
      # and make only IPv4 connections. When you enable IPv6, sockets will accept
      # and connect to both IPv4 and IPv6 peers. You can override the setting on
      # each zsock_t instance. The default is IPv4 only (ipv6 set to 0). If the
      # environment variable ZSYS_IPV6 is defined (as 1 or 0), this provides the
      # default. Note: has no effect on ZMQ v2.
      #
      # @param ipv6 [Integer, #to_int, #to_i]
      # @return [void]
      def self.set_ipv6(ipv6)
        ipv6 = Integer(ipv6)
        result = ::CZMQ::FFI.zsys_set_ipv6(ipv6)
        result
      end

      # Return use of IPv6 for zsock instances.
      #
      # @return [Integer]
      def self.ipv6()
        result = ::CZMQ::FFI.zsys_ipv6()
        result
      end

      # Test if ipv6 is available on the system. Return true if available.
      # The only way to reliably check is to actually open a socket and
      # try to bind it. (ported from libzmq)
      #
      # @return [Boolean]
      def self.ipv6_available()
        result = ::CZMQ::FFI.zsys_ipv6_available()
        result
      end

      # Set network interface name to use for broadcasts, particularly zbeacon.
      # This lets the interface be configured for test environments where required.
      # For example, on Mac OS X, zbeacon cannot bind to 255.255.255.255 which is
      # the default when there is no specified interface. If the environment
      # variable ZSYS_INTERFACE is set, use that as the default interface name.
      # Setting the interface to "*" means "use all available interfaces".
      #
      # @param value [String, #to_s, nil]
      # @return [void]
      def self.set_interface(value)
        result = ::CZMQ::FFI.zsys_set_interface(value)
        result
      end

      # Return network interface to use for broadcasts, or "" if none was set.
      #
      # @return [String]
      def self.interface()
        result = ::CZMQ::FFI.zsys_interface()
        result
      end

      # Set IPv6 address to use zbeacon socket, particularly for receiving zbeacon.
      # This needs to be set IPv6 is enabled as IPv6 can have multiple addresses
      # on a given interface. If the environment variable ZSYS_IPV6_ADDRESS is set,
      # use that as the default IPv6 address.
      #
      # @param value [String, #to_s, nil]
      # @return [void]
      def self.set_ipv6_address(value)
        result = ::CZMQ::FFI.zsys_set_ipv6_address(value)
        result
      end

      # Return IPv6 address to use for zbeacon reception, or "" if none was set.
      #
      # @return [String]
      def self.ipv6_address()
        result = ::CZMQ::FFI.zsys_ipv6_address()
        result
      end

      # Set IPv6 milticast address to use for sending zbeacon messages. This needs
      # to be set if IPv6 is enabled. If the environment variable
      # ZSYS_IPV6_MCAST_ADDRESS is set, use that as the default IPv6 multicast
      # address.
      #
      # @param value [String, #to_s, nil]
      # @return [void]
      def self.set_ipv6_mcast_address(value)
        result = ::CZMQ::FFI.zsys_set_ipv6_mcast_address(value)
        result
      end

      # Return IPv6 multicast address to use for sending zbeacon, or "" if none was
      # set.
      #
      # @return [String]
      def self.ipv6_mcast_address()
        result = ::CZMQ::FFI.zsys_ipv6_mcast_address()
        result
      end

      # Set IPv4 multicast address to use for sending zbeacon messages. By default
      # IPv4 multicast is NOT used. If the environment variable
      # ZSYS_IPV4_MCAST_ADDRESS is set, use that as the default IPv4 multicast
      # address. Calling this function or setting ZSYS_IPV4_MCAST_ADDRESS
      # will enable IPv4 zbeacon messages.
      #
      # @param value [String, #to_s, nil]
      # @return [void]
      def self.set_ipv4_mcast_address(value)
        result = ::CZMQ::FFI.zsys_set_ipv4_mcast_address(value)
        result
      end

      # Return IPv4 multicast address to use for sending zbeacon, or NULL if none was
      # set.
      #
      # @return [String]
      def self.ipv4_mcast_address()
        result = ::CZMQ::FFI.zsys_ipv4_mcast_address()
        result
      end

      # Set multicast TTL default is 1
      #
      # @param value [Integer, #to_int, #to_i]
      # @return [void]
      def self.set_mcast_ttl(value)
        value = Integer(value)
        result = ::CZMQ::FFI.zsys_set_mcast_ttl(value)
        result
      end

      # Get multicast TTL
      #
      # @return [Integer]
      def self.mcast_ttl()
        result = ::CZMQ::FFI.zsys_mcast_ttl()
        result
      end

      # Configure the automatic use of pre-allocated FDs when creating new sockets.
      # If 0 (default), nothing will happen. Else, when a new socket is bound, the
      # system API will be used to check if an existing pre-allocated FD with a
      # matching port (if TCP) or path (if IPC) exists, and if it does it will be
      # set via the ZMQ_USE_FD socket option so that the library will use it
      # instead of creating a new socket.
      #
      # @param auto_use_fd [Integer, #to_int, #to_i]
      # @return [void]
      def self.set_auto_use_fd(auto_use_fd)
        auto_use_fd = Integer(auto_use_fd)
        result = ::CZMQ::FFI.zsys_set_auto_use_fd(auto_use_fd)
        result
      end

      # Return use of automatic pre-allocated FDs for zsock instances.
      #
      # @return [Integer]
      def self.auto_use_fd()
        result = ::CZMQ::FFI.zsys_auto_use_fd()
        result
      end

      # Print formatted string. Format is specified by variable names
      # in Python-like format style
      #
      # "%(KEY)s=%(VALUE)s", KEY=key, VALUE=value
      # become
      # "key=value"
      #
      # Returns freshly allocated string or NULL in a case of error.
      # Not enough memory, invalid format specifier, name not in args
      #
      # @param format [String, #to_s, nil]
      # @param args [Zhash, #__ptr]
      # @return [::FFI::AutoPointer]
      def self.zprintf(format, args)
        args = args.__ptr if args
        result = ::CZMQ::FFI.zsys_zprintf(format, args)
        result = ::FFI::AutoPointer.new(result, LibC.method(:free))
        result
      end

      # Return error string for given format/args combination.
      #
      # @param format [String, #to_s, nil]
      # @param args [Zhash, #__ptr]
      # @return [::FFI::AutoPointer]
      def self.zprintf_error(format, args)
        args = args.__ptr if args
        result = ::CZMQ::FFI.zsys_zprintf_error(format, args)
        result = ::FFI::AutoPointer.new(result, LibC.method(:free))
        result
      end

      # Print formatted string. Format is specified by variable names
      # in Python-like format style
      #
      # "%(KEY)s=%(VALUE)s", KEY=key, VALUE=value
      # become
      # "key=value"
      #
      # Returns freshly allocated string or NULL in a case of error.
      # Not enough memory, invalid format specifier, name not in args
      #
      # @param format [String, #to_s, nil]
      # @param args [Zconfig, #__ptr]
      # @return [::FFI::AutoPointer]
      def self.zplprintf(format, args)
        args = args.__ptr if args
        result = ::CZMQ::FFI.zsys_zplprintf(format, args)
        result = ::FFI::AutoPointer.new(result, LibC.method(:free))
        result
      end

      # Return error string for given format/args combination.
      #
      # @param format [String, #to_s, nil]
      # @param args [Zconfig, #__ptr]
      # @return [::FFI::AutoPointer]
      def self.zplprintf_error(format, args)
        args = args.__ptr if args
        result = ::CZMQ::FFI.zsys_zplprintf_error(format, args)
        result = ::FFI::AutoPointer.new(result, LibC.method(:free))
        result
      end

      # Set log identity, which is a string that prefixes all log messages sent
      # by this process. The log identity defaults to the environment variable
      # ZSYS_LOGIDENT, if that is set.
      #
      # @param value [String, #to_s, nil]
      # @return [void]
      def self.set_logident(value)
        result = ::CZMQ::FFI.zsys_set_logident(value)
        result
      end

      # Set stream to receive log traffic. By default, log traffic is sent to
      # stdout. If you set the stream to NULL, no stream will receive the log
      # traffic (it may still be sent to the system facility).
      #
      # @param stream [::FFI::Pointer, #to_ptr]
      # @return [void]
      def self.set_logstream(stream)
        result = ::CZMQ::FFI.zsys_set_logstream(stream)
        result
      end

      # Sends log output to a PUB socket bound to the specified endpoint. To
      # collect such log output, create a SUB socket, subscribe to the traffic
      # you care about, and connect to the endpoint. Log traffic is sent as a
      # single string frame, in the same format as when sent to stdout. The
      # log system supports a single sender; multiple calls to this method will
      # bind the same sender to multiple endpoints. To disable the sender, call
      # this method with a null argument.
      #
      # @param endpoint [String, #to_s, nil]
      # @return [void]
      def self.set_logsender(endpoint)
        result = ::CZMQ::FFI.zsys_set_logsender(endpoint)
        result
      end

      # Enable or disable logging to the system facility (syslog on POSIX boxes,
      # event log on Windows). By default this is disabled.
      #
      # @param logsystem [Boolean]
      # @return [void]
      def self.set_logsystem(logsystem)
        logsystem = !(0==logsystem||!logsystem) # boolean
        result = ::CZMQ::FFI.zsys_set_logsystem(logsystem)
        result
      end

      # Log error condition - highest priority
      #
      # @param format [String, #to_s, nil]
      # @param args [Array<Object>] see https://github.com/ffi/ffi/wiki/examples#using-varargs
      # @return [void]
      def self.error(format, *args)
        result = ::CZMQ::FFI.zsys_error(format, *args)
        result
      end

      # Log warning condition - high priority
      #
      # @param format [String, #to_s, nil]
      # @param args [Array<Object>] see https://github.com/ffi/ffi/wiki/examples#using-varargs
      # @return [void]
      def self.warning(format, *args)
        result = ::CZMQ::FFI.zsys_warning(format, *args)
        result
      end

      # Log normal, but significant, condition - normal priority
      #
      # @param format [String, #to_s, nil]
      # @param args [Array<Object>] see https://github.com/ffi/ffi/wiki/examples#using-varargs
      # @return [void]
      def self.notice(format, *args)
        result = ::CZMQ::FFI.zsys_notice(format, *args)
        result
      end

      # Log informational message - low priority
      #
      # @param format [String, #to_s, nil]
      # @param args [Array<Object>] see https://github.com/ffi/ffi/wiki/examples#using-varargs
      # @return [void]
      def self.info(format, *args)
        result = ::CZMQ::FFI.zsys_info(format, *args)
        result
      end

      # Log debug-level message - lowest priority
      #
      # @param format [String, #to_s, nil]
      # @param args [Array<Object>] see https://github.com/ffi/ffi/wiki/examples#using-varargs
      # @return [void]
      def self.debug(format, *args)
        result = ::CZMQ::FFI.zsys_debug(format, *args)
        result
      end

      # Self test of this class.
      #
      # @param verbose [Boolean]
      # @return [void]
      def self.test(verbose)
        verbose = !(0==verbose||!verbose) # boolean
        result = ::CZMQ::FFI.zsys_test(verbose)
        result
      end
    end
  end
end

################################################################################
#  THIS FILE IS 100% GENERATED BY ZPROJECT; DO NOT EDIT EXCEPT EXPERIMENTALLY  #
#  Read the zproject/README.md for information about making permanent changes. #
################################################################################
