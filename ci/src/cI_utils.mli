open! Result
open Asetmap

module Log: Logs.LOG
val src: Logs.src

module Client9p: sig
  include Protocol_9p_client.S
  val connect:
    string -> string ->
    ?msize:int32 -> ?username:string -> ?aname:string -> unit ->
    t Protocol_9p_error.t Lwt.t
end
module DK: sig
  include Datakit_S.CLIENT with type error = Protocol_9p_error.error
  val connect: Client9p.t -> t
end

module IntMap: Map.S with type key = int
module Int: sig type t = int val compare: t -> t -> int end

val chdir_lock: Lwt_mutex.t

val ok: 'a -> ('a, 'b) result Lwt.t

val ( >>*= ): ('a, [< `Msg of string ]) result Lwt.t -> ('a -> 'b Lwt.t) -> 'b Lwt.t

val ( >|*= ): ('a, [< `Msg of string ]) result Lwt.t -> ('a -> 'b) -> 'b Lwt.t

val return_error:
  ('a, Format.formatter, unit, ('b, string) result Lwt.t) format4 -> 'a

val failf: ('a, Format.formatter, unit, 'b) format4 -> 'a

val pp_exn: exn Fmt.t

val with_timeout:
  ?switch:Lwt_switch.t -> float -> (Lwt_switch.t -> 'a Lwt.t) -> 'a Lwt.t

val abs_path: string -> string

val ensure_dir: mode:Unix.file_perm -> string -> unit

val default: 'a -> 'a option -> 'a

val with_tmpdir:
  ?prefix:string -> ?mode:Unix.file_perm -> (string -> 'a Lwt.t) -> 'a Lwt.t

val ls: string -> string list Lwt.t

val with_switch: (Lwt_switch.t -> 'a Lwt.t) -> 'a Lwt.t

val cancel_when_off: Lwt_switch.t -> (unit -> 'a Lwt.t) -> 'a Lwt.t
