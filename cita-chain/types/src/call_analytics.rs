// Copyright 2015-2017 Parity Technologies (UK) Ltd.
// This file is part of Parity.

// This software is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This software is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with Parity.  If not, see <http://www.gnu.org/licenses/>.

//! Call analytics related types

/// Options concerning what analytics we run on the call.
#[derive(Eq, PartialEq, Default, Clone, Copy, Debug)]
#[cfg_attr(feature = "ipc", binary)]
pub struct CallAnalytics {
    /// Make a transaction trace.
    pub transaction_tracing: bool,
    /// Make a VM trace.
    pub vm_tracing: bool,
    /// Make a diff.
    pub state_diffing: bool,
}
