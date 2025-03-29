# 시스템 아키텍쳐 개요
요구사항을 충족하기 위한 시스템은 Control Plane(제어 서비스)와 Client SDK(클라이언트 에이전트)의 이원 구조로 설계된다. 전체 아키텍처의 주요 구성 요소는 다음과 같다.

### Feature Flag 제어 서비스(Feature Flag Control Service)
Elixir/Phoenix 기반의 중앙 관리 서비스로, 모든 Feature Flag의 정의와 상태를 관리하는 컨트롤 플레인이다 ￼. 이 서비스는 관리자 UI 및 API를 통해 Feature Flag 생성/변경 요청을 처리하고, Flag 설정을 영구 저장소에 기록한다.

### 데이터 저장소(Data Store)
Feature Flag 설정과 정책을 저장하는 영구 저장소이다. 신뢰성과 일관성을 위해 PostgreSQL과 같은 RDBMS를 한다. 선택한 저장소는 높은 가용성을 갖춰야 하며 Feature Flag 설정을 안정적으로 유지해야 한다.

### API 및 통신 레이어
클라이언트 애플리케이션이 Feature Flag 정보를 가져갈 수 있도록 API 엔드포인트가 제공된다. Phoenix 기반의 JSON API 통해 초기 전체 Flag 구성 fetch를 지원한다. 또한 실시간 업데이트를 전송하기 위한 통신 채널(SSE)을 제공하여, 서버-클라이언트 간 지속 연결을 유지한다.

### 클라이언트 SDK/에이전트
각 애플리케이션(웹 프론트엔드, 백엔드 서비스 등)에 포함되어 동작하는 Feature Flag SDK이다.
이 SDK는 초기화 시 서버에서 모든 Feature Flag 설정을 불러와 로컬 캐시에 저장하고,
애플리케이션 코드가 Flag 상태를 조회할 수 있는 간단한 함수를 제공한다 
(예: FeatureFlag.is_enabled?(:플래그명, 사용자컨텍스트) 형태). 

SDK는 백그라운드에서 중앙 서비스와의 동기화를 담당하며, 내부적으로 로컬 메모리 캐시를 지속적으로 업데이트한다. Flag 평가(결정)는 SDK 내부에서 로컬 데이터 기반으로 수행되어, 네트워크 지연 없이 즉각적이다.

### 관리자 UI (Admin UI)
관리자나 DevOps 팀이 Feature Flag를 설정하는 웹 애플리케이션 UI이다. 
Phoenix LiveView 등을 이용해 실시간 상호작용이 가능하도록 구현한다.
메인 클라이언트 UI는 React로 구성하되 백엔드 API를 호출하는 형태로 구현한다. 
이 UI를 통해 새 Flag 등록, 토글 on/off, 대상 조건 편집, 스케줄 설정 등이 이루어지며, 모든 변경은 제어 서비스의 API를 통해 처리된다.
