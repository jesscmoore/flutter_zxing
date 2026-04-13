//
// ZxingSymbolAnchor.m
//
// Prevents the linker's dead-code stripping from removing the native ZXing
// C functions when flutter_zxing is statically linked into the host app.
// Without an explicit reference, the linker considers these symbols unreachable
// (they are only looked up at runtime via dlsym) and strips them, causing
// DynamicLibrary.process().lookup('readBarcode') to fail on iOS.
//

#import <Foundation/Foundation.h>

// Forward-declare the C functions. Signatures intentionally omitted — we only
// need the linker to see these as live references, not to call them correctly.
extern void readBarcode(void);
extern void readBarcodes(void);
extern void encodeBarcode(void);
extern void version(void);
extern void setLogEnabled(void);

// Taking the address of each function creates a hard reference that survives
// dead-code stripping, ensuring dlsym can find them at runtime.
__attribute__((used))
static void* const _zxingSymbolAnchor[] = {
    (void*)&readBarcode,
    (void*)&readBarcodes,
    (void*)&encodeBarcode,
    (void*)&version,
    (void*)&setLogEnabled,
};
