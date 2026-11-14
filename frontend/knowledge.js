/* Bảng tri thức F2 dùng chung cho các trang (result, home, history).
   Nạp f2_knowledge.json rồi dựng 2 biến GROUPS và CLASSES theo đúng dạng các trang đang dùng.
   Cách dùng:  await loadKnowledge();  rồi dùng GROUPS, CLASSES, normLabel() như bình thường. */

/* Khi backend có GET /guide thì đổi thành URL của API, ví dụ "http://localhost:8000/guide" */
const KNOWLEDGE_URL="f2_knowledge.json";

/* Nhãn kiểu cũ của giao diện mẫu -> nhãn của mô hình (labels.json) */
const LEGACY_LABELS={plastic:"nhua",metal:"kim_loai",paper:"giay",glass:"thuy_tinh",food:"huu_co",hazard:"pin_nguy_hai",soft:"rac_khac",other:"rac_khac"};
const FALLBACK_LABEL="rac_khac";

let GROUPS={}, CLASSES={};

async function loadKnowledge(){
  const res=await fetch(KNOWLEDGE_URL);
  if(!res.ok)throw new Error("Không tải được bảng tri thức F2 ("+res.status+")");
  const data=await res.json();
  GROUPS={};CLASSES={};
  for(const [k,g] of Object.entries(data.groups)){
    GROUPS[k]={name:g.short,fullName:g.name,color:g.color,icon:g.icon,hint:g.hint||""};
  }
  for(const [k,c] of Object.entries(data.labels)){
    CLASSES[k]={
      name:c.name, g:c.group, warning:c.warning,
      how:c.guide.summary, steps:c.guide.steps||[], dont:c.guide.dont||[],
      idea:c.guide.reuse||"", examples:c.guide.examples||[]
    };
  }
}

/* Trả về nhãn hợp lệ: nhãn mô hình giữ nguyên, nhãn cũ được đổi, nhãn lạ về "rac_khac" */
function normLabel(k){
  if(CLASSES[k])return k;
  const m=LEGACY_LABELS[k];
  return CLASSES[m]?m:FALLBACK_LABEL;
}