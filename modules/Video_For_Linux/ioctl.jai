//
// Ioctl codes. These are defined via a series of macros in ioctl.h. Bindings_Generator doesn't seem to expand the macros, maybe it
// is possible to make it, but for now I just define the macros here. These might be useful for other linux apis.
//

// NOTE(Charles): In c headers, these constants can have their values overriden by the code including. Not sure why...

_IOC_NRBITS   :: 8;
_IOC_TYPEBITS :: 8;
_IOC_SIZEBITS :: 14;
_IOC_DIRBITS  :: 2;

_IOC_NRMASK   :: (1 << _IOC_NRBITS)   - 1;
_IOC_TYPEMASK :: (1 << _IOC_TYPEBITS) - 1;
_IOC_SIZEMASK :: (1 << _IOC_SIZEBITS) - 1;
_IOC_DIRMASK  :: (1 << _IOC_DIRBITS)  - 1;

_IOC_NRSHIFT   :: 0;
_IOC_TYPESHIFT :: _IOC_NRSHIFT   + _IOC_NRBITS;
_IOC_SIZESHIFT :: _IOC_TYPESHIFT + _IOC_TYPEBITS;
_IOC_DIRSHIFT  :: _IOC_SIZESHIFT + _IOC_SIZEBITS;

_IOC_NONE  :: 0;
_IOC_WRITE :: 1;
_IOC_READ  :: 2;

IOC_IN        :: _IOC_WRITE << _IOC_DIRSHIFT;
IOC_OUT       :: _IOC_READ  << _IOC_DIRSHIFT;
IOC_INOUT     :: (_IOC_WRITE|_IOC_READ) << _IOC_DIRSHIFT;
IOCSIZE_MASK  :: _IOC_SIZEMASK << _IOC_SIZESHIFT;
IOCSIZE_SHIFT :: _IOC_SIZESHIFT;

// NOTE(Charles): Hmm, I made this return u64 because the paramter to ioctl takes u64, but all the codes are actually u32s?
_IOC :: (dir: u64, type: u64, nr: u64, size: u64) -> u64 #expand {
    result := (dir  << _IOC_DIRSHIFT) | (type << _IOC_TYPESHIFT) | (nr << _IOC_NRSHIFT) | (size << _IOC_SIZESHIFT);
    return result;
}

_IOC_TYPECHECK :: (t: Type) -> u64 #expand { return size_of(t); }

/*
 * Used to create numbers.
 *
 * NOTE: _IOW means userland is writing and kernel is reading. _IOR
 * means userland is reading and kernel is writing.
 */

_IO       :: (type: u64, nr: u64)             -> u64 #expand { return _IOC(_IOC_NONE,  type, nr, 0); }
_IOR      :: (type: u64, nr: u64, size: Type) -> u64 #expand { return _IOC(_IOC_READ,  type, nr, _IOC_TYPECHECK(size)); }
_IOW      :: (type: u64, nr: u64, size: Type) -> u64 #expand { return _IOC(_IOC_WRITE, type, nr, _IOC_TYPECHECK(size)); }
_IOWR     :: (type: u64, nr: u64, size: Type) -> u64 #expand { return _IOC(_IOC_READ|_IOC_WRITE, type, nr, _IOC_TYPECHECK(size)); }
// _IOR_BAD  :: (type: u64, nr: u64, size: Type) -> u64 #expand { return _IOC(_IOC_READ,  type, nr, size_of(size)); }
// _IOW_BAD  :: (type: u64, nr: u64, size: Type) -> u64 #expand { return _IOC(_IOC_WRITE, type, nr, size_of(size)); }
// _IOWR_BAD :: (type: u64, nr: u64, size: Type) -> u64 #expand { return _IOC(_IOC_READ|_IOC_WRITE, type, nr, size_of(size)); }