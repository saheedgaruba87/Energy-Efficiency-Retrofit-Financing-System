;; Property Registry Contract
;; Manages property registration, ownership, and baseline energy data

;; Error constants
(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-INVALID-INPUT (err u101))
(define-constant ERR-NOT-FOUND (err u102))
(define-constant ERR-ALREADY-EXISTS (err u103))

;; Data structures
(define-map properties
  { property-id: uint }
  {
    owner: principal,
    address: (string-ascii 200),
    property-type: (string-ascii 50),
    square-footage: uint,
    year-built: uint,
    baseline-energy-usage: uint, ;; kWh per year
    current-value: uint, ;; in micro-STX
    last-updated: uint,
    status: (string-ascii 20)
  }
)

(define-map property-energy-history
  { property-id: uint, timestamp: uint }
  {
    energy-usage: uint,
    cost: uint,
    source: (string-ascii 50)
  }
)

(define-map property-owners
  { owner: principal }
  { property-count: uint }
)

;; Data variables
(define-data-var next-property-id uint u1)
(define-data-var contract-owner principal tx-sender)

;; Authorization check
(define-private (is-authorized (property-id uint) (caller principal))
  (match (map-get? properties { property-id: property-id })
    property-data (is-eq caller (get owner property-data))
    false
  )
)

;; Register a new property
(define-public (register-property
  (address (string-ascii 200))
  (property-type (string-ascii 50))
  (square-footage uint)
  (year-built uint)
  (baseline-energy-usage uint)
  (current-value uint)
)
  (let ((property-id (var-get next-property-id)))
    (asserts! (> square-footage u0) ERR-INVALID-INPUT)
    (asserts! (> year-built u1800) ERR-INVALID-INPUT)
    (asserts! (< year-built u2030) ERR-INVALID-INPUT)
    (asserts! (> current-value u0) ERR-INVALID-INPUT)

    (map-set properties
      { property-id: property-id }
      {
        owner: tx-sender,
        address: address,
        property-type: property-type,
        square-footage: square-footage,
        year-built: year-built,
        baseline-energy-usage: baseline-energy-usage,
        current-value: current-value,
        last-updated: block-height,
        status: "active"
      }
    )

    (map-set property-owners
      { owner: tx-sender }
      { property-count: (+ (get-property-count tx-sender) u1) }
    )

    (var-set next-property-id (+ property-id u1))
    (ok property-id)
  )
)

;; Update property value
(define-public (update-property-value (property-id uint) (new-value uint))
  (let ((property-data (unwrap! (map-get? properties { property-id: property-id }) ERR-NOT-FOUND)))
    (asserts! (is-authorized property-id tx-sender) ERR-NOT-AUTHORIZED)
    (asserts! (> new-value u0) ERR-INVALID-INPUT)

    (map-set properties
      { property-id: property-id }
      (merge property-data {
        current-value: new-value,
        last-updated: block-height
      })
    )
    (ok true)
  )
)

;; Add energy usage data
(define-public (add-energy-data
  (property-id uint)
  (energy-usage uint)
  (cost uint)
  (source (string-ascii 50))
)
  (begin
    (asserts! (is-authorized property-id tx-sender) ERR-NOT-AUTHORIZED)
    (asserts! (> energy-usage u0) ERR-INVALID-INPUT)

    (map-set property-energy-history
      { property-id: property-id, timestamp: block-height }
      {
        energy-usage: energy-usage,
        cost: cost,
        source: source
      }
    )
    (ok true)
  )
)

;; Transfer property ownership
(define-public (transfer-property (property-id uint) (new-owner principal))
  (let ((property-data (unwrap! (map-get? properties { property-id: property-id }) ERR-NOT-FOUND)))
    (asserts! (is-authorized property-id tx-sender) ERR-NOT-AUTHORIZED)

    ;; Update old owner count
    (map-set property-owners
      { owner: tx-sender }
      { property-count: (- (get-property-count tx-sender) u1) }
    )

    ;; Update new owner count
    (map-set property-owners
      { owner: new-owner }
      { property-count: (+ (get-property-count new-owner) u1) }
    )

    ;; Transfer ownership
    (map-set properties
      { property-id: property-id }
      (merge property-data {
        owner: new-owner,
        last-updated: block-height
      })
    )
    (ok true)
  )
)

;; Read-only functions
(define-read-only (get-property (property-id uint))
  (map-get? properties { property-id: property-id })
)

(define-read-only (get-property-count (owner principal))
  (default-to u0 (get property-count (map-get? property-owners { owner: owner })))
)

(define-read-only (get-energy-data (property-id uint) (timestamp uint))
  (map-get? property-energy-history { property-id: property-id, timestamp: timestamp })
)

(define-read-only (get-next-property-id)
  (var-get next-property-id)
)
