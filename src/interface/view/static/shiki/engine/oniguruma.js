var P=class extends Error{constructor(t){super(t),this.name="ShikiError"}};function W(){return 2147483648}function H(){return typeof performance<"u"?performance.now():Date.now()}var v=(n,t)=>n+(t-n%t)%t;async function x(n){let t,r,e={};function l(f){r=f,e.HEAPU8=new Uint8Array(f),e.HEAPU32=new Uint32Array(f)}function h(f,c,A){e.HEAPU8.copyWithin(f,c,c+A)}function o(f){try{return t.grow(f-r.byteLength+65535>>>16),l(t.buffer),1}catch{}}function s(f){let c=e.HEAPU8.length;f=f>>>0;let A=W();if(f>A)return!1;for(let L=1;L<=4;L*=2){let p=c*(1+.2/L);p=Math.min(p,f+100663296);let w=Math.min(A,v(Math.max(f,p),65536));if(o(w))return!0}return!1}let i=typeof TextDecoder<"u"?new TextDecoder("utf8"):void 0;function a(f,c,A=1024){let L=c+A,p=c;for(;f[p]&&!(p>=L);)++p;if(p-c>16&&f.buffer&&i)return i.decode(f.subarray(c,p));let w="";for(;c<p;){let m=f[c++];if(!(m&128)){w+=String.fromCharCode(m);continue}let O=f[c++]&63;if((m&224)===192){w+=String.fromCharCode((m&31)<<6|O);continue}let E=f[c++]&63;if((m&240)===224?m=(m&15)<<12|O<<6|E:m=(m&7)<<18|O<<12|E<<6|f[c++]&63,m<65536)w+=String.fromCharCode(m);else{let M=m-65536;w+=String.fromCharCode(55296|M>>10,56320|M&1023)}}return w}function U(f,c){return f?a(e.HEAPU8,f,c):""}let u={emscripten_get_now:H,emscripten_memcpy_big:h,emscripten_resize_heap:s,fd_write:()=>0};async function y(){let c=await n({env:u,wasi_snapshot_preview1:u});t=c.memory,l(t.buffer),Object.assign(e,c),e.UTF8ToString=U}return await y(),e}var I=Object.defineProperty,D=(n,t,r)=>t in n?I(n,t,{enumerable:!0,configurable:!0,writable:!0,value:r}):n[t]=r,d=(n,t,r)=>(D(n,typeof t!="symbol"?t+"":t,r),r),g=null;function V(n){throw new P(n.UTF8ToString(n.getLastOnigError()))}var S=class n{constructor(t){d(this,"utf16Length"),d(this,"utf8Length"),d(this,"utf16Value"),d(this,"utf8Value"),d(this,"utf16OffsetToUtf8"),d(this,"utf8OffsetToUtf16");let r=t.length,e=n._utf8ByteLength(t),l=e!==r,h=l?new Uint32Array(r+1):null;l&&(h[r]=e);let o=l?new Uint32Array(e+1):null;l&&(o[e]=r);let s=new Uint8Array(e),i=0;for(let a=0;a<r;a++){let U=t.charCodeAt(a),u=U,y=!1;if(U>=55296&&U<=56319&&a+1<r){let f=t.charCodeAt(a+1);f>=56320&&f<=57343&&(u=(U-55296<<10)+65536|f-56320,y=!0)}l&&(h[a]=i,y&&(h[a+1]=i),u<=127?o[i+0]=a:u<=2047?(o[i+0]=a,o[i+1]=a):u<=65535?(o[i+0]=a,o[i+1]=a,o[i+2]=a):(o[i+0]=a,o[i+1]=a,o[i+2]=a,o[i+3]=a)),u<=127?s[i++]=u:u<=2047?(s[i++]=192|(u&1984)>>>6,s[i++]=128|(u&63)>>>0):u<=65535?(s[i++]=224|(u&61440)>>>12,s[i++]=128|(u&4032)>>>6,s[i++]=128|(u&63)>>>0):(s[i++]=240|(u&1835008)>>>18,s[i++]=128|(u&258048)>>>12,s[i++]=128|(u&4032)>>>6,s[i++]=128|(u&63)>>>0),y&&a++}this.utf16Length=r,this.utf8Length=e,this.utf16Value=t,this.utf8Value=s,this.utf16OffsetToUtf8=h,this.utf8OffsetToUtf16=o}static _utf8ByteLength(t){let r=0;for(let e=0,l=t.length;e<l;e++){let h=t.charCodeAt(e),o=h,s=!1;if(h>=55296&&h<=56319&&e+1<l){let i=t.charCodeAt(e+1);i>=56320&&i<=57343&&(o=(h-55296<<10)+65536|i-56320,s=!0)}o<=127?r+=1:o<=2047?r+=2:o<=65535?r+=3:r+=4,s&&e++}return r}createString(t){let r=t.omalloc(this.utf8Length);return t.HEAPU8.set(this.utf8Value,r),r}},_=class{constructor(n){if(d(this,"id",++_.LAST_ID),d(this,"_onigBinding"),d(this,"content"),d(this,"utf16Length"),d(this,"utf8Length"),d(this,"utf16OffsetToUtf8"),d(this,"utf8OffsetToUtf16"),d(this,"ptr"),!g)throw new P("Must invoke loadWasm first.");this._onigBinding=g,this.content=n;let t=new S(n);this.utf16Length=t.utf16Length,this.utf8Length=t.utf8Length,this.utf16OffsetToUtf8=t.utf16OffsetToUtf8,this.utf8OffsetToUtf16=t.utf8OffsetToUtf16,this.utf8Length<1e4&&!_._sharedPtrInUse?(_._sharedPtr||(_._sharedPtr=g.omalloc(1e4)),_._sharedPtrInUse=!0,g.HEAPU8.set(t.utf8Value,_._sharedPtr),this.ptr=_._sharedPtr):this.ptr=t.createString(g)}convertUtf8OffsetToUtf16(n){return this.utf8OffsetToUtf16?n<0?0:n>this.utf8Length?this.utf16Length:this.utf8OffsetToUtf16[n]:n}convertUtf16OffsetToUtf8(n){return this.utf16OffsetToUtf8?n<0?0:n>this.utf16Length?this.utf8Length:this.utf16OffsetToUtf8[n]:n}dispose(){this.ptr===_._sharedPtr?_._sharedPtrInUse=!1:this._onigBinding.ofree(this.ptr)}},T=_;d(T,"LAST_ID",0);d(T,"_sharedPtr",0);d(T,"_sharedPtrInUse",!1);var C=class{constructor(t){if(d(this,"_onigBinding"),d(this,"_ptr"),!g)throw new P("Must invoke loadWasm first.");let r=[],e=[];for(let s=0,i=t.length;s<i;s++){let a=new S(t[s]);r[s]=a.createString(g),e[s]=a.utf8Length}let l=g.omalloc(4*t.length);g.HEAPU32.set(r,l/4);let h=g.omalloc(4*t.length);g.HEAPU32.set(e,h/4);let o=g.createOnigScanner(l,h,t.length);for(let s=0,i=t.length;s<i;s++)g.ofree(r[s]);g.ofree(h),g.ofree(l),o===0&&V(g),this._onigBinding=g,this._ptr=o}dispose(){this._onigBinding.freeOnigScanner(this._ptr)}findNextMatchSync(t,r,e){let l=0;if(typeof e=="number"&&(l=e),typeof t=="string"){t=new T(t);let h=this._findNextMatchSync(t,r,!1,l);return t.dispose(),h}return this._findNextMatchSync(t,r,!1,l)}_findNextMatchSync(t,r,e,l){let h=this._onigBinding,o=h.findNextOnigScannerMatch(this._ptr,t.id,t.ptr,t.utf8Length,t.convertUtf16OffsetToUtf8(r),l);if(o===0)return null;let s=h.HEAPU32,i=o/4,a=s[i++],U=s[i++],u=[];for(let y=0;y<U;y++){let f=t.convertUtf8OffsetToUtf16(s[i++]),c=t.convertUtf8OffsetToUtf16(s[i++]);u[y]={start:f,end:c,length:c-f}}return{index:a,captureIndices:u}}};function N(n){return typeof n.instantiator=="function"}function F(n){return typeof n.default=="function"}function R(n){return typeof n.data<"u"}function j(n){return typeof Response<"u"&&n instanceof Response}function z(n){return typeof ArrayBuffer<"u"&&(n instanceof ArrayBuffer||ArrayBuffer.isView(n))||typeof Buffer<"u"&&Buffer.isBuffer?.(n)||typeof SharedArrayBuffer<"u"&&n instanceof SharedArrayBuffer||typeof Uint32Array<"u"&&n instanceof Uint32Array}var b;function G(n){if(b)return b;async function t(){g=await x(async r=>{let e=n;return e=await e,typeof e=="function"&&(e=await e(r)),typeof e=="function"&&(e=await e(r)),N(e)?e=await e.instantiator(r):F(e)?e=await e.default(r):(R(e)&&(e=e.data),j(e)?typeof WebAssembly.instantiateStreaming=="function"?e=await k(e)(r):e=await J(e)(r):z(e)?e=await B(e)(r):e instanceof WebAssembly.Module?e=await B(e)(r):"default"in e&&e.default instanceof WebAssembly.Module&&(e=await B(e.default)(r))),"instance"in e&&(e=e.instance),"exports"in e&&(e=e.exports),e})}return b=t(),b}function B(n){return t=>WebAssembly.instantiate(n,t)}function k(n){return t=>WebAssembly.instantiateStreaming(n,t)}function J(n){return async t=>{let r=await n.arrayBuffer();return WebAssembly.instantiate(r,t)}}async function K(n){return n&&await G(n),{createScanner(t){return new C(t.map(r=>typeof r=="string"?r:r.source))},createString(t){return new T(t)}}}export{K as createOnigurumaEngine};