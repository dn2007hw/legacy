(* io.sig
 *
 * COPYRIGHT (c) 2019 The Fellowship of SML/NJ (http://www.smlnj.org)
 * All rights reserved.
 *)

signature IO =
  sig

    exception Io of {
	name : string,
	function : string,
	cause : exn
      }

    exception BlockingNotSupported
    exception NonblockingNotSupported
    exception RandomAccessNotSupported
    exception TerminatedStream
    exception ClosedStream

    datatype buffer_mode = NO_BUF | LINE_BUF | BLOCK_BUF

  end
