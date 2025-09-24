flowchart TD

    A[Cache Phase<br/>Quick script e.g., fix_dns.sh] -->|git add + commit| B[Main Branch<br/>"feat: add quick DNS fix script"]

    B --> C[Refactor Phase<br/>Convert script → Ansible role<br/>"refactor: dns_fix role"]

    C --> D[Incremental Phase<br/>Small commits + docs<br/>"feat: multi-DNS support"<br/>"docs: KB entry"]

    D --> E[Growth Phase<br/>Experiment in branches<br/>feature/dns_resolver → main]

    E --> F[Personal Infra / Knowledge Base<br/>Always cached + improving]
