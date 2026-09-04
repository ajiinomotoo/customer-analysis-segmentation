# Customer Analysis & Segmentation

Analisis perilaku customer menggunakan **RFM Analysis** dan **Customer Segmentation** untuk mengidentifikasi customer value, retention opportunity, dan revenue contribution.

## Project Overview

Project ini menganalisis perilaku pembelian customer berdasarkan data transaksi menggunakan metode **RFM (Recency, Frequency, Monetary)**.

Analisis dilakukan untuk memahami karakteristik setiap customer segment, mengidentifikasi customer bernilai tinggi, menemukan customer yang berpotensi membutuhkan strategi retention, serta menghasilkan rekomendasi bisnis berdasarkan hasil analisis.

Project ini menggunakan **Power Query** untuk data cleaning, **MySQL** untuk data preparation dan analysis, serta **Power BI** untuk data visualization dan dashboard interaktif.

## Business Problem

Perusahaan memiliki data transaksi customer dalam jumlah besar, tetapi belum memiliki gambaran yang jelas mengenai customer value dan purchasing behavior.

Tanpa segmentasi customer, perusahaan akan kesulitan menentukan:

- Customer mana yang paling bernilai
- Customer mana yang perlu dipertahankan
- Customer mana yang berpotensi kehilangan engagement
- Customer mana yang memiliki peluang untuk dikembangkan
- Segment mana yang memberikan kontribusi revenue terbesar

Project ini menggunakan pendekatan berbasis data untuk membantu mengidentifikasi customer segment dan menentukan prioritas strategi customer retention serta customer development.

## Tujuan Analisis

- Membersihkan dan mempersiapkan data transaksi
- Menghitung Recency, Frequency, dan Monetary untuk setiap customer
- Memberikan RFM Score menggunakan skala 1–5
- Melakukan customer segmentation berdasarkan karakteristik RFM
- Menganalisis distribusi customer dan revenue pada setiap segment
- Mengidentifikasi high-value customers dan retention opportunity
- Membuat dashboard interaktif menggunakan Power BI
- Menghasilkan business insights dan recommendations berdasarkan hasil analisis

## Analytical Questions

1. Bagaimana distribusi customer berdasarkan RFM segment?
2. Segment customer mana yang memberikan kontribusi revenue terbesar?
3. Berapa besar revenue yang berasal dari Champions dan Loyal Customers?
4. Berapa banyak customer yang berada pada segment At Risk dan Hibernating?
5. Berapa besar historical revenue yang berasal dari At Risk dan Hibernating customers?
6. Siapa customer dengan Monetary value tertinggi?
7. Seberapa terkonsentrasi revenue pada top customers?
8. Bagaimana karakteristik RFM pada setiap customer segment?
9. Segment mana yang perlu mendapatkan prioritas retention?
10. Strategi bisnis apa yang dapat diterapkan berdasarkan hasil customer segmentation?

## Dataset

**Dataset:** UCI Online Retail Dataset

**Periode transaksi:** 1 Desember 2010 – 9 Desember 2011

### Dataset Awal

- 541.909 transaction rows
- 8 columns

### Dataset Setelah Cleaning

- 392.692 transaction rows
- 4.337 customers

### Kolom Utama

| Kolom | Deskripsi |
|---|---|
| InvoiceNo | Nomor invoice transaksi |
| StockCode | Kode produk |
| Description | Deskripsi produk |
| Quantity | Jumlah produk yang dibeli |
| InvoiceDate | Tanggal dan waktu transaksi |
| UnitPrice | Harga per unit |
| CustomerID | ID customer |
| Country | Negara customer |

## Tools & Technologies

| Tools | Penggunaan |
|---|---|
| **Excel / Power Query** | Data cleaning dan transformation |
| **MySQL** | Data preparation, RFM analysis, segmentation, dan business analysis |
| **Power BI** | Data visualization dan interactive dashboard |
| **GitHub** | Version control dan portfolio |
| **Notion** | Project documentation |

## Data Cleaning

Data cleaning dilakukan menggunakan **Power Query**.

Tahapan utama:

- Menghapus duplicate transactions
- Menghapus transaksi tanpa CustomerID
- Menghapus transaksi dengan Quantity <= 0
- Menghapus transaksi dengan UnitPrice <= 0
- Membuat kolom Revenue

**Revenue = Quantity × UnitPrice**

Setelah proses cleaning, diperoleh **392.692 transaction rows**.

## Outlier Handling

Pada tahap exploratory analysis ditemukan dua transaksi dengan nilai Quantity dan Revenue yang sangat ekstrem.

Kedua transaksi tersebut dikeluarkan dari proses RFM calculation untuk mencegah nilai ekstrem mendominasi perhitungan Monetary dan memengaruhi customer segmentation.

Sebelum exclusion, transaksi tersebut juga diperiksa berdasarkan customer dan transaction history untuk memastikan keputusan handling outlier dilakukan secara terkontrol.

## RFM Methodology

Customer dianalisis menggunakan tiga dimensi RFM:

### Recency

Mengukur berapa lama sejak customer terakhir melakukan transaksi.

**Reference Date:** 10 Desember 2011

**Recency = Reference Date - Last Transaction Date**

Semakin kecil nilai Recency, semakin baru transaksi customer.

### Frequency

Mengukur jumlah transaksi yang dilakukan customer.

**Frequency = COUNT(DISTINCT InvoiceNo)**

Semakin tinggi Frequency, semakin sering customer melakukan transaksi.

### Monetary

Mengukur total revenue yang dihasilkan customer.

**Monetary = SUM(Revenue)**

Semakin tinggi Monetary, semakin besar nilai customer terhadap bisnis.

## RFM Scoring

Setiap metrik RFM diberikan score **1–5 menggunakan NTILE(5)**.

- **Recency:** customer yang lebih baru bertransaksi mendapatkan score lebih tinggi
- **Frequency:** customer dengan transaksi lebih sering mendapatkan score lebih tinggi
- **Monetary:** customer dengan nilai revenue lebih tinggi mendapatkan score lebih tinggi

Ketiga score kemudian digabungkan menjadi **RFM Score**.

Contoh:

**555**

menunjukkan customer dengan score tinggi pada ketiga dimensi RFM.

## Customer Segmentation

Customer dikelompokkan menggunakan **custom RFM-based segmentation framework**.

Segment yang digunakan:

| Segment | Karakteristik Umum |
|---|---|
| **Champions** | Customer sangat aktif dan memiliki customer value tinggi |
| **Loyal Customers** | Customer dengan engagement dan value yang baik |
| **Potential Loyalists** | Customer aktif yang memiliki peluang berkembang |
| **Promising** | Customer yang menunjukkan potensi untuk berkembang |
| **At Risk** | Customer yang mulai menunjukkan penurunan engagement |
| **Hibernating** | Customer yang sudah lama tidak melakukan transaksi |
| **Needs Attention** | Customer dengan kombinasi RFM yang membutuhkan perhatian lebih lanjut |

> **Catatan:** Segmentasi merupakan custom framework yang dibuat khusus untuk project ini berdasarkan kombinasi RFM Score, bukan klasifikasi RFM universal.

## Power BI Dashboard

Dashboard dibuat menggunakan Power BI untuk memberikan overview mengenai customer segmentation dan revenue contribution.

### KPI

- Total Customers
- Total Revenue
- Average Customer Value

### Visualizations

- Customer Distribution by Segment
- Revenue Contribution by Segment
- Average Customer Value by Segment

### Interactive Filters

- Segment
- Retention Priority

### Dashboard Preview

![Customer Analysis & Segmentation Dashboard](powerbi/screenshots/dashboard-preview.png)

## Key Insights

### 1. Customer bernilai tinggi menjadi kontributor utama revenue

Champions mencakup **23,01% customer base**, tetapi menghasilkan **67,37% total revenue**.

Jika Champions dan Loyal Customers digabungkan, keduanya mencakup **41,43% customer base** namun menghasilkan **82,08% total revenue**.

Hal ini menunjukkan bahwa mempertahankan customer bernilai tinggi memiliki dampak besar terhadap revenue.

### 2. At Risk customers memiliki retention opportunity yang signifikan

Terdapat **526 At Risk customers** dengan historical revenue sebesar **£764.503,16**.

Average customer value segment ini mencapai **£1.453,43**, sehingga At Risk customers menjadi kelompok yang lebih menarik untuk strategi retention dibandingkan Hibernating customers.

### 3. Hibernating merupakan segment terbesar

Hibernating terdiri dari **1.210 customers atau 27,90% customer base**, tetapi hanya menghasilkan **5,82% total revenue**.

Jumlah customer yang besar tidak selalu menunjukkan prioritas bisnis yang tinggi.

### 4. Revenue cukup terkonsentrasi pada top customers

Top 10 customers menghasilkan sekitar **£1,42 juta**, atau **16,48% dari total revenue**.

Hal ini menunjukkan adanya konsentrasi revenue pada sejumlah customer bernilai tinggi yang perlu diperhatikan dalam strategi customer retention.

### 5. Prioritas retention perlu mempertimbangkan customer value

At Risk customers memiliki average customer value yang jauh lebih tinggi dibandingkan Hibernating customers.

Karena itu, strategi retention sebaiknya tidak diterapkan secara sama kepada seluruh customer yang mulai tidak aktif, tetapi diprioritaskan berdasarkan **segment dan customer value**.

## Business Recommendations

### Champions

**Fokus: Retention**

- Loyalty program
- Personalized offers
- Exclusive benefits
- Priority customer service

### Loyal Customers

**Fokus: Customer Development**

- Cross-selling
- Upselling
- Loyalty incentives
- Product recommendations

### At Risk

**Fokus: Win-back**

- Targeted retention campaigns
- Personalized promotions
- Re-engagement campaigns
- Prioritaskan customer dengan Monetary value tinggi

### Hibernating

**Fokus: Selective Reactivation**

- Gunakan low-cost reactivation campaigns
- Prioritaskan customer secara selektif
- Hindari pemberian incentive besar secara massal

### Promising & Potential Loyalists

**Fokus: Customer Development**

- Mendorong repeat purchase
- Product recommendations
- Cross-selling
- Engagement campaigns

## Project Structure

```text
customer-analysis-segmentation/
│
├── data/
│   ├── raw/
│   │   └── Online Retail.xlsx
│   │
│   └── cleaned/
│       └── clean_online_retail_sql.csv
│
├── powerbi/
│   ├── customer-analysis-segmentation.pbix
│   └── screenshots/
│       └── dashboard-preview.png
│
└── sql/
    ├── 01-create-database.sql
    ├── 02-create-table.sql
    ├── 03-segment-analysis.sql
    ├── 04-powerbi-dataset.sql
    └── 05-insight-analysis.sql
```

## Kesimpulan

Analisis RFM menunjukkan adanya perbedaan yang signifikan dalam customer engagement dan customer value.

Sebagian besar revenue berasal dari customer bernilai tinggi, sementara sebagian besar customer yang sudah lama tidak aktif memiliki kontribusi revenue yang relatif lebih kecil.

Berdasarkan hasil analisis, strategi customer sebaiknya dibedakan berdasarkan segment.

Prioritas utama adalah:

Mempertahankan Champions
Mengembangkan Loyal Customers
Melakukan targeted win-back terhadap At Risk customers
Melakukan selective reactivation terhadap Hibernating customers
Mengembangkan Promising dan Potential Loyalists

Project ini menunjukkan bagaimana transaction-level data dapat diolah menjadi customer-level insights dan diterjemahkan menjadi actionable business recommendations.
