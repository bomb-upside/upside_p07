# P07 Publish

학생 배포용 Foundry 패키지입니다.

포함 내용:
- `src/`: UUPS / Beacon / Diamond 실습 소스
- `test/`: practice / answer 테스트
- `script/`: 배포 스크립트

주의:
- `test/*answer.t.sol`은 정답 테스트라 GitHub 공개 대상에서 제외합니다.
- generated artifact(`out/`, `cache/`, `broadcast/`)는 커밋하지 않습니다.

## Clone

신규 clone:

```bash
git clone --recurse-submodules <repo-url>
cd P07_publish
```

이미 clone한 경우:

```bash
git submodule update --init --recursive
```

## Build

```bash
forge build
```

## Tests

정답 테스트:

```bash
forge test --match-path 'test/*.answer.t.sol' -vv
```

학생용 practice 테스트:

```bash
forge test --match-path 'test/*.practice.t.sol' -vv
```
