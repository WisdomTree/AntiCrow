{
  description = "A Nix-flake-based development environment for TypeScript";

  inputs = {
    # 최신 버전을 선호한다면 nixpkgs-unstable을, 안정된 버전을 원한다면 nixos-23.11 등 특정 버전을 사용합니다.
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell {
          # 개발 환경에 필요한 패키지 목록
          packages = with pkgs; [
            nodejs_24    # Node.js 최신 LTS (안정적인 24 버전)
            pnpm         # npm 대신 사용하기 위해 복구됨
            typescript   # 전역 타입스크립트
            typescript-language-server # 에디터 자동완성 지원 지원용 LSP

            # 추가된 유틸리티
            wrangler     # Cloudflare R2 VSIX 업로드용 (wrangler.toml 기반)
            nixpkgs-fmt  # Nix 파일 포매터
          ];

          # Nix 쉘이 활성화될 때 실행될 훅 
          shellHook = ''
            echo "🟢 Node.js 버전: $(node --version)"
            echo "📦 pnpm 버전: $(pnpm --version)"
          '';
        };
      }
    );
}
