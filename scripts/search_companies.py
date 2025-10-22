import requests
import csv
import urllib.parse
from typing import List, Dict
import time
from datetime import datetime

def search_company(keyword: str) -> List[Dict]:
    """
    ค้นหาข้อมูลบริษัทจาก API
    
    Args:
        keyword: ชื่อบริษัทที่ต้องการค้นหา
    
    Returns:
        List ของข้อมูลบริษัทที่พบ
    """
    base_url = "https://ecqyzf1qgi.execute-api.ap-southeast-1.amazonaws.com/prod/rdcontact"
    
    # Encode keyword เป็น URL format
    encoded_keyword = urllib.parse.quote(keyword)
    url = f"{base_url}?ocr=false&keyword={encoded_keyword}"
    
    try:
        response = requests.get(url, timeout=30)
        response.raise_for_status()
        data = response.json()
        
        if data.get('status') and data.get('data', {}).get('list'):
            results = data['data']['list']
            # เพิ่ม keyword ที่ใช้ค้นหาเข้าไปในแต่ละ result
            for result in results:
                result['search_keyword'] = keyword
            return results
        else:
            print(f"  ⚠ ไม่พบข้อมูลสำหรับ: {keyword}")
            return []
    except Exception as e:
        print(f"  ❌ เกิดข้อผิดพลาดในการค้นหา '{keyword}': {str(e)}")
        return []

def save_to_csv(all_results: List[Dict], output_file: str = 'companies_result.csv'):
    """
    บันทึกข้อมูลลง CSV file
    
    Args:
        all_results: List ของข้อมูลบริษัททั้งหมด
        output_file: ชื่อไฟล์ที่ต้องการบันทึก
    """
    if not all_results:
        print("\n❌ ไม่มีข้อมูลให้บันทึก")
        return
    
    # กำหนด fieldnames จากข้อมูลที่ได้รับ พร้อม search_keyword
    fieldnames = ['search_keyword', 'taxId', 'name', 'branch', 'branchCode', 
                  'branchType', 'addressLocal', 'zipCode', 'contactGroup']
    
    with open(output_file, 'w', newline='', encoding='utf-8-sig') as csvfile:
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames, extrasaction='ignore')
        writer.writeheader()
        writer.writerows(all_results)
    
    print(f"\n{'='*60}")
    print(f"✅ บันทึกข้อมูลเรียบร้อย: {output_file}")
    print(f"📊 จำนวนรายการทั้งหมด: {len(all_results)} รายการ")
    print(f"{'='*60}")

def read_company_list(file_path: str) -> List[str]:
    """
    อ่านรายชื่อบริษัทจากไฟล์
    
    Args:
        file_path: path ของไฟล์ที่มีรายชื่อบริษัท
    
    Returns:
        List ของชื่อบริษัท
    """
    companies = []
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            for line in f:
                company = line.strip()
                # ข้ามบรรทัดว่างและบรรทัดที่มีแค่ quotes
                if company and company not in ['""', '"']:
                    companies.append(company)
        return companies
    except Exception as e:
        print(f"❌ เกิดข้อผิดพลาดในการอ่านไฟล์: {str(e)}")
        return []

def main():
    """
    ฟังก์ชันหลักสำหรับค้นหาบริษัท
    """
    # อ่านรายชื่อบริษัทจากไฟล์
    input_file = '/Users/sathitseethaphon/projects/dms-invs-projects/invs-modern/scripts/company.txt'
    
    print("🔍 กำลังอ่านรายชื่อบริษัท...")
    company_names = read_company_list(input_file)
    
    if not company_names:
        print("❌ ไม่พบรายชื่อบริษัทในไฟล์")
        return
    
    print(f"✅ พบบริษัททั้งหมด {len(company_names)} รายการ")
    print(f"\n{'='*60}")
    print(f"เริ่มค้นหาข้อมูล... (เวลาเริ่มต้น: {datetime.now().strftime('%H:%M:%S')})")
    print(f"{'='*60}\n")
    
    all_results = []
    success_count = 0
    not_found_count = 0
    error_count = 0
    
    for idx, company_name in enumerate(company_names, 1):
        print(f"[{idx}/{len(company_names)}] กำลังค้นหา: {company_name}")
        results = search_company(company_name)
        
        if results:
            print(f"  ✅ พบ {len(results)} รายการ")
            all_results.extend(results)
            success_count += 1
        elif results == []:
            not_found_count += 1
        else:
            error_count += 1
        
        # หน่วงเวลาเล็กน้อยเพื่อไม่ให้ API ถูก rate limit
        time.sleep(0.3)
        
        # แสดง progress ทุกๆ 50 รายการ
        if idx % 50 == 0:
            print(f"\n📊 Progress: {idx}/{len(company_names)} ({idx*100//len(company_names)}%)")
            print(f"   ✅ พบข้อมูล: {success_count} | ⚠ ไม่พบ: {not_found_count} | ❌ Error: {error_count}\n")
    
    print(f"\n{'='*60}")
    print(f"🎉 เสร็จสิ้นการค้นหา! (เวลาสิ้นสุด: {datetime.now().strftime('%H:%M:%S')})")
    print(f"{'='*60}")
    print(f"📊 สรุปผลการค้นหา:")
    print(f"   • ค้นหาทั้งหมด: {len(company_names)} รายการ")
    print(f"   • ✅ พบข้อมูล: {success_count} รายการ")
    print(f"   • ⚠ ไม่พบข้อมูล: {not_found_count} รายการ")
    print(f"   • ❌ เกิดข้อผิดพลาด: {error_count} รายการ")
    print(f"   • 📦 รวมข้อมูลที่ได้: {len(all_results)} records")
    print(f"{'='*60}")
    
    # บันทึกเป็น CSV
    if all_results:
        output_file = '/Users/sathitseethaphon/projects/dms-invs-projects/invs-modern/scripts/companies_result.csv'
        save_to_csv(all_results, output_file)
    else:
        print("\n❌ ไม่มีข้อมูลให้บันทึก")

if __name__ == "__main__":
    main()
