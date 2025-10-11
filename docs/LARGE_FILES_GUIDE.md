# Large Files Management Guide
## คู่มือจัดการไฟล์ขนาดใหญ่

---

## 🎯 **ปัญหา**

Repository มีไฟล์ขนาดใหญ่ที่ไม่เหมาะสำหรับ Git:
- **01-invs-legacy-schema.sql** - 340MB (schema + data)
- **01-schema-only.sql** - 26MB (schema only)
- **INVS_MySQL_Database_20231119.sql** - ~1.4GB (full dump)
- **TMT Excel files** - 50+ files, ~30MB total

GitHub มีข้อจำกัด:
- ⚠️ ไฟล์เดียว > 50MB จะถูก warning
- ❌ ไฟล์เดียว > 100MB จะถูก reject
- ⚠️ Repository > 1GB ไม่แนะนำ

---

## ✅ **แนวทางแก้ไข**

### **วิธีที่ 1: ใช้ .gitignore + Cloud Storage** ⭐ (แนะนำ)

#### ขั้นตอน:

1. **เพิ่มไฟล์ใน .gitignore** ✅ (ทำแล้ว)
   ```
   scripts/legacy-init/01-invs-legacy-schema.sql
   scripts/legacy-init/01-schema-only.sql
   scripts/INVS_MySQL_Database_*.sql
   docs/manual-invs/TMTRF20250915/**/*.xls
   ```

2. **Upload ไฟล์ไปยัง Cloud Storage**

   เลือก 1 ใน:
   - **Google Drive** (ฟรี 15GB)
   - **Dropbox** (ฟรี 2GB)
   - **OneDrive** (ฟรี 5GB)
   - **AWS S3** (pay-as-you-go)
   - **GitHub Releases** (สำหรับไฟล์ release)

3. **สร้างสคริปต์ดาวน์โหลด**
   ```bash
   # scripts/download-large-files.sh
   ```

#### ข้อดี:
✅ ไม่ทำให้ repo ใหญ่
✅ Clone เร็ว
✅ ไม่เสียเงิน (ใช้ free tier)
✅ ควบคุมได้ว่าใครควรมีไฟล์

#### ข้อเสีย:
❌ ต้องดาวน์โหลดแยก
❌ ต้องจัดการ 2 ที่

---

### **วิธีที่ 2: Git LFS (Large File Storage)**

#### ขั้นตอน:

1. **ติดตั้ง Git LFS**
   ```bash
   # macOS
   brew install git-lfs

   # Linux
   sudo apt-get install git-lfs

   # Windows
   # Download from: https://git-lfs.github.com/
   ```

2. **Initialize Git LFS**
   ```bash
   git lfs install
   ```

3. **Track large files**
   ```bash
   git lfs track "scripts/legacy-init/*.sql"
   git lfs track "docs/manual-invs/**/*.xls"
   git add .gitattributes
   ```

4. **Commit และ Push**
   ```bash
   git add .
   git commit -m "Add large files with LFS"
   git push
   ```

#### ข้อดี:
✅ ใช้งานง่าย เหมือน git ปกติ
✅ Clone ได้เลยไม่ต้องดาวน์โหลดแยก
✅ Version control ได้

#### ข้อเสีย:
❌ GitHub LFS ฟรีแค่ 1GB bandwidth/เดือน
❌ เกิน 1GB ต้องจ่ายเงิน ($5/50GB)
❌ Clone ช้ากว่าปกติ

---

### **วิธีที่ 3: แยก Repository**

สร้าง repository แยกสำหรับ legacy data:

```
invs-modern/                    # Main application
invs-legacy-data/              # Legacy database dumps
```

#### ข้อดี:
✅ แยกกันชัดเจน
✅ Main repo เบาและเร็ว
✅ จัดการ permission ได้แยก

#### ข้อเสีย:
❌ ต้องจัดการ 2 repos
❌ ซับซ้อนขึ้น

---

### **วิธีที่ 4: ลบไฟล์ออกจาก History** (ถ้าคอมมิตไปแล้ว)

ถ้าไฟล์ใหญ่ถูกคอมมิตไปแล้ว ต้องลบออกจาก git history:

```bash
# ใช้ BFG Repo Cleaner (แนะนำ)
brew install bfg

# ลบไฟล์ที่ใหญ่กว่า 50M
bfg --strip-blobs-bigger-than 50M .git

# หรือลบไฟล์เฉพาะ
bfg --delete-files "01-invs-legacy-schema.sql" .git

# Clean up
git reflog expire --expire=now --all
git gc --prune=now --aggressive

# Force push (⚠️ ระวัง! จะเขียนทับ history)
git push --force
```

---

## 📋 **ไฟล์ที่ควร Ignore**

### ไฟล์ขนาดใหญ่ (>50MB):
```gitignore
# Legacy SQL dumps
scripts/legacy-init/01-invs-legacy-schema.sql     # 340MB
scripts/legacy-init/01-schema-only.sql            # 26MB
scripts/INVS_MySQL_Database_*.sql                 # 1.4GB

# TMT Excel reference data
docs/manual-invs/TMTRF20250915/**/*.xls
docs/manual-invs/TMTRF20250915/**/*.xlsx
```

### ไฟล์ที่ควรเก็บใน Git:
```
✅ prisma/schema.prisma           # Database schema (important!)
✅ prisma/functions.sql           # 16KB - OK
✅ prisma/views.sql               # 14KB - OK
✅ prisma/seed.ts                 # Seed script - OK
✅ docs/**/*.md                   # Documentation - OK
✅ src/**/*.ts                    # Source code - OK
```

---

## 🚀 **แนวทางที่แนะนำสำหรับ INVS Modern**

### **ขั้นตอนที่ 1: Remove large files from git** ✅

```bash
# Already done - added to .gitignore
```

### **ขั้นตอนที่ 2: Create download script**

สร้างสคริปต์ดาวน์โหลดไฟล์ใหญ่:

```bash
#!/bin/bash
# scripts/download-large-files.sh

echo "📥 Downloading large files..."

# Create directories
mkdir -p scripts/legacy-init
mkdir -p docs/manual-invs/TMTRF20250915

# Download from Google Drive (example)
# Replace FILE_ID with actual Google Drive file ID
LEGACY_SCHEMA_ID="YOUR_FILE_ID_HERE"
SCHEMA_ONLY_ID="YOUR_FILE_ID_HERE"
MYSQL_DUMP_ID="YOUR_FILE_ID_HERE"

echo "Downloading 01-invs-legacy-schema.sql..."
# gdown $LEGACY_SCHEMA_ID -O scripts/legacy-init/01-invs-legacy-schema.sql

echo "Downloading 01-schema-only.sql..."
# gdown $SCHEMA_ONLY_ID -O scripts/legacy-init/01-schema-only.sql

echo "Downloading MySQL dump..."
# gdown $MYSQL_DUMP_ID -O scripts/INVS_MySQL_Database_20231119.sql

echo "✅ Download complete!"
echo "ℹ️  If files are not available, contact: your-email@example.com"
```

### **ขั้นตอนที่ 3: Upload files to cloud**

1. **สร้าง Google Drive folder**
   - ชื่อ: "INVS-Modern-Large-Files"
   - แชร์เป็น "Anyone with the link can view"

2. **Upload files**:
   - 01-invs-legacy-schema.sql
   - 01-schema-only.sql
   - INVS_MySQL_Database_20231119.sql
   - TMTRF20250915.zip (รวม Excel ทั้งหมด)

3. **Get shareable links**
   - Right click → Get link → Copy link

4. **Update README.md** with download instructions

### **ขั้นตอนที่ 4: Update documentation**

```markdown
# README.md

## Large Files

Some files are too large for Git and are hosted separately.

### Required for development:
None - the application works without legacy data

### Optional (for legacy data migration):
Download from: [Google Drive Link]
- 01-invs-legacy-schema.sql (340MB)
- 01-schema-only.sql (26MB)
- INVS_MySQL_Database_20231119.sql (1.4GB)

Or run: `./scripts/download-large-files.sh`
```

---

## 📊 **ขนาด Repository**

### ก่อนทำความสะอาด:
```
Repository size: ~1.5GB
- Source code: ~10MB
- Documentation: ~20MB
- Large SQL files: ~1.4GB ❌
- TMT Excel: ~30MB
- Other: ~40MB
```

### หลังทำความสะอาด:
```
Repository size: ~60MB ✅
- Source code: ~10MB
- Documentation: ~20MB
- Scripts (small): ~5MB
- Other: ~25MB
```

**ผลลัพธ์: ลดขนาดลง 96%** 🎉

---

## ✅ **Checklist**

- [x] เพิ่มไฟล์ใหญ่ใน .gitignore
- [ ] Remove files from git history (ถ้าคอมมิตไปแล้ว)
- [ ] Upload files to cloud storage
- [ ] สร้างสคริปต์ดาวน์โหลด
- [ ] Update README.md
- [ ] ทดสอบ clone repository ใหม่
- [ ] แจ้งทีมเกี่ยวกับการเปลี่ยนแปลง

---

## 🔧 **Useful Commands**

```bash
# ตรวจสอบขนาดไฟล์ใหญ่
find . -type f -size +10M -exec ls -lh {} \; | awk '{print $5, $9}'

# ตรวจสอบขนาด repository
du -sh .git

# ตรวจสอบไฟล์ที่ถูก track
git ls-files --cached

# ตรวจสอบว่าไฟล์ถูก ignore หรือไม่
git check-ignore -v scripts/legacy-init/01-invs-legacy-schema.sql

# ลบไฟล์จาก git cache (ถ้าคอมมิตไปแล้ว)
git rm --cached scripts/legacy-init/01-invs-legacy-schema.sql
git commit -m "Remove large SQL file from tracking"
```

---

## 📞 **Support**

หากมีปัญหาเกี่ยวกับการดาวน์โหลดไฟล์:
1. ตรวจสอบว่า link ยังใช้งานได้
2. ติดต่อ: [your-email@example.com]
3. หรือดูที่: docs/LARGE_FILES_GUIDE.md

---

## 🔗 **External Resources**

- [Git LFS](https://git-lfs.github.com/)
- [BFG Repo-Cleaner](https://rtyley.github.io/bfg-repo-cleaner/)
- [GitHub File Size Limits](https://docs.github.com/en/repositories/working-with-files/managing-large-files/about-large-files-on-github)
- [gdown - Google Drive downloader](https://github.com/wkentaro/gdown)

---

**Last Updated**: 2025-01-10
**Status**: Active ✅

*Maintained with ❤️ by the INVS Modern Team*
