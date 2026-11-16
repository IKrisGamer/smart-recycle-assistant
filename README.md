# Smart Recycle Assistant

Trợ lý AI hỗ trợ phân loại và tái chế rác thải tại nguồn (Đồ án 4).

Người dùng chụp ảnh rác, mô hình AI nhận diện loại vật liệu. Hệ thống cho biết rác thuộc nhóm nào và hướng dẫn cách xử lý. Chatbot giải đáp thắc mắc về phân loại rác.

## Phân công

Mỗi người làm trọn một nhóm chức năng, từ AI, backend đến giao diện, để cả 3 người đều hiểu toàn bộ hệ thống.

| | A | B | C |
|---|---|---|---|
| **Thành viên** | Yến Nhi | Thanh Tính | Bảo Trâm |
| **Chức năng** | F1 nhận diện rác bằng ảnh, F5 lịch sử | F3 chatbot RAG, F4 đăng ký/đăng nhập | F2 hướng dẫn xử lý, F6 thống kê, F7 sửa nhãn |
| **AI** | Huấn luyện mô hình nhận diện ảnh (MobileNetV2) | Tài liệu tri thức, embedding, LLM cho chatbot | Phân tích lỗi mô hình (confusion matrix), dùng nhãn người dùng sửa để cải thiện mô hình |
| **Backend** | `POST /predict`, lưu lịch sử, `GET /history` | Khung FastAPI và CSDL, `POST /chat`, `/auth/register`, `/auth/login` (JWT) | Bảng tri thức F2, `GET /stats`, lưu nhãn sửa |
| **Giao diện** | Màn hình chụp/tải ảnh, kết quả, trang lịch sử | Khung chat, form đăng ký/đăng nhập | Thẻ hướng dẫn, biểu đồ, nút "Kết quả sai?"; giữ CSS và bố cục chung |
| **Báo cáo** | Chương mô hình nhận diện ảnh | Chương chatbot, kiến trúc hệ thống | Chương phân tích dữ liệu, đánh giá, kết luận; tổng hợp báo cáo |

F8 điểm thưởng, F9 bản đồ, F10 trang quản trị làm sau nếu còn thời gian.

## Tình trạng

| Phần | Trạng thái |
|---|---|
| Mô hình nhận diện ảnh (A) | Xong bản đầu: MobileNetV2, 7 lớp, 90,56% trên tập test, 83 ms/ảnh. Chưa có lớp `tui_ni_long_xop`. File mô hình không đưa lên Git. |
| Giao diện | 7 trang HTML tĩnh trong `frontend/`, chưa nối API |
| Backend (B) | Xong khung FastAPI, `/health`, SQLite và 6 bảng (PR #13) |
| Tiếp theo | B nạp dữ liệu mẫu, sau đó `POST /predict` dùng nhãn giả để A nạp mô hình vào |

## Nhóm rác

Hệ thống dùng 4 nhóm. Mã vật liệu trùng với nhãn trong `labels.json` của mô hình.

| Nhóm (`waste_groups.code`) | Vật liệu (`materials.code`) |
|---|---|
| `tai_che`: rác tái chế | `giay`, `nhua`, `kim_loai`, `thuy_tinh` |
| `huu_co`: rác hữu cơ | `huu_co` |
| `nguy_hai`: rác nguy hại (hiện cảnh báo, mang đến điểm thu gom riêng) | `pin_nguy_hai` |
| `con_lai`: rác còn lại | `rac_khac` |

## Cấu trúc thư mục

```
ai/          notebook huấn luyện, dữ liệu, mô hình (dữ liệu và *.keras không commit)
backend/
  app/
    main.py        khởi tạo FastAPI, CORS, tạo bảng
    database.py    kết nối SQLite, get_db, utcnow
    models/        6 bảng: users, waste_groups, materials, guides, scan_sessions, chat_messages
    routers/       mỗi nhóm API một file (predict, history, chat, auth, stats)
    services/      xử lý nghiệp vụ, ví dụ tra hướng dẫn
  requirements.txt
frontend/    giao diện HTML
docs/        báo cáo, use case, wireframe, api.md
```

## Chạy backend

Yêu cầu Python 3.10 trở lên. Chạy trong thư mục `backend`:

```bash
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt
uvicorn app.main:app --reload
```

Mở http://127.0.0.1:8000/health thấy `{"status":"ok"}` là được, xem các API tại http://127.0.0.1:8000/docs. File CSDL `smart_recycle.db` tự tạo khi chạy lần đầu. Khi đổi cấu trúc bảng thì xóa file này rồi chạy lại.

## Quy ước làm việc

1. **Mỗi tầng có một người chốt cấu trúc chung.** B giữ khung backend và CSDL, A và C thêm router của mình vào `backend/app/routers/`. C giữ CSS và bố cục chung.
2. **Thống nhất định dạng API trước khi code**, ghi vào `docs/api.md`.
3. **Mỗi việc một nhánh `feature/...`** tạo từ `main` mới nhất. Không push thẳng lên `main`. Tạo Pull Request, người khác review rồi mới merge.
4. Trước khi commit, chạy `git branch --show-current` và `git status` để chắc chắn đúng nhánh, đúng file.
5. Không commit `.env`, `.venv/`, bộ dữ liệu ảnh, file mô hình `*.keras` và file CSDL `*.db`.
6. Mỗi tuần 15 phút để từng người trình bày phần vừa làm cho 2 người còn lại.
