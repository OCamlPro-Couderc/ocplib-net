(**************************************************************************)
(*                                                                        *)
(*    Copyright 2017-2018 OCamlPro                                        *)
(*                                                                        *)
(*  All rights reserved. This file is distributed under the terms of the  *)
(*  GNU Lesser General Public License version 2.1, with the special       *)
(*  exception on linking described in the file LICENSE.                   *)
(*                                                                        *)
(**************************************************************************)

(* [main ()] returns when [exit n] is called, with result [n]. In the
   meantime, it runs the Lwt loop. *)
val main : unit -> int
val exit : int -> unit

(* [defer f] defers execution of [f] after all currently executable
   continuations. *)
val defer : (unit -> 'a Lwt.t) -> unit

(* [wakeup u] will wake thread [u] after all currently executable
   continuations. *)
val wakeup : unit Lwt.u -> unit
