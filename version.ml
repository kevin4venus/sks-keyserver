(***********************************************************************)
(* version.ml - Executable: Show version information                   *)
(*                                                                     *)
(* Copyright (C) 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010, *)
(*               2011, 2012  Yaron Minsky and Contributors             *)
(*                                                                     *)
(* This file is part of SKS.  SKS is free software; you can            *)
(* redistribute it and/or modify it under the terms of the GNU General *)
(* Public License as published by the Free Software Foundation; either *)
(* version 2 of the License, or (at your option) any later version.    *)
(*                                                                     *)
(* This program is distributed in the hope that it will be useful, but *)
(* WITHOUT ANY WARRANTY; without even the implied warranty of          *)
(* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU   *)
(* General Public License for more details.                            *)
(*                                                                     *)
(* You should have received a copy of the GNU General Public License   *)
(* along with this program; if not, write to the Free Software         *)
(* Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 *)
(* USA or see <http://www.gnu.org/licenses/>.                          *)
(***********************************************************************)

open Printf

let bdb_version = Bdb.version ()

let sopen dirname flags mode = 
    let dbenv = Bdb.Dbenv.create (); in
    Bdb.Dbenv.dopen dbenv dirname flags mode; 
    dbenv

let stats = 
	let dbenv = sopen (Lazy.force Settings.dbdir) [Bdb.Dbenv.CREATE] 0o400 in
	let s = Bdb.Dbenv.get_dbenv_stats(dbenv) in 
	s

let dbstats_dir = 
   let split = Str.regexp_string "." in
   let s = 
     match Str.split split bdb_version with
       | major::minor::_ -> sprintf "Further details can be seen by executing \
         db%s.%s_stat -x in the KDB and Ptree directories\n" major minor;
       | [] | _::[] -> sprintf "Further details can be seen by executing \
         db%s.%s_stat -x in the KDB and Ptree directories\n" "X" "Y" in
	s
	 
let run() =  
   printf "SKS version %s%s\nThis version has a minimum compatibility \
   requirement for recon of SKS %s\n" Common.version
   Common.version_suffix Common.compatible_version_string;
   
   printf "Compiled with BDB version %s\n" bdb_version;
   printf "Detailed BDB environment statistics:\n%s" stats;
   printf "%s" dbstats_dir; 
   