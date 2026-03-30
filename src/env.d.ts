/// <reference path="../.astro/types.d.ts" />
/// <reference types="astro/client" />
/// <reference types="@titaniumnetwork-dev/ultraviolet/client" />
///  <reference types="@mercuryworkshop/scramjet" />
interface Window {
  __uv$config: {
    prefix: string;
    encodeUrl: (url: string) => string;
    decodeUrl: (url: string) => string;
    handler: string;
    bundle: string;
    config: string;
    sw: string;
  };
}

declare const __uv$config: any;
