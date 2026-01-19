from flask import Flask, request, jsonify
import requests

app = Flask(__name__)

# DeepSeek model API ayarları
API_URL = "http://127.0.0.1:1234/v1/chat/completions"
MODEL_NAME = "deepseek/deepseek-r1-0528-qwen3-8b"

@app.route("/get_ai_suggestion", methods=["POST"])
def get_ai_suggestion():
    data = request.json
    task = data.get("task", "").strip()
    category = data.get("category", "genel").strip()  # yemek, sağlık, eğitim, kişisel, iş
    
    if not task:
        return jsonify({"suggestion": ""})
    
    # Kategoriye göre sistem prompt'u oluştur
    category_prompts = {
        "yemek": (
            "Sen bir yemek tarifi asistanısın. Kullanıcının istediği yemeğin yapımıyla ilgili "
            "kısa, pratik öneriler ver. Sadece tarifi ve yapılışını anlat, başka açıklama yapma. "
            "Türkçe cevap ver."
        ),
        "sağlık": (
            "Sen bir sağlık danışmanısın. Ancak unutma: Bu sadece genel tavsiyedir, "
            "tıbbi teşhis veya tedavi değildir. Kullanıcının sağlıkla ilgili görevi için "
            "kısa, pratik, güvenli öneriler ver. Türkçe cevap ver."
        ),
        "eğitim": (
            "Sen bir eğitim koçusun. Kullanıcının öğrenme hedefi için "
            "kısa, uygulanabilir, pratik öneriler ver. Türkçe cevap ver."
        ),
        "kişisel": (
            "Sen bir kişisel gelişim asistanısın. Kullanıcının kişisel görevi için "
            "motivasyonel, pratik ve uygulanabilir öneriler ver. Türkçe cevap ver."
        ),
        "iş": (
            "Sen bir iş/proje asistanısın. Kullanıcının iş görevi için "
            "kısa, net, pratik ve uygulanabilir öneriler ver. Türkçe cevap ver."
        ),
        "genel": (
            "Sen bir üretkenlik asistanısın. Kullanıcının görevi için "
            "kısa, pratik ve uygulanabilir adımlar öner. Türkçe cevap ver."
        )
    }
    
    system_prompt = category_prompts.get(category, category_prompts["genel"])
    
    payload = {
        "model": MODEL_NAME,
        "messages": [
            {
                "role": "system",
                "content": system_prompt
            },
            {
                "role": "user", 
                "content": f"'{task}' görevi için bana kısa, pratik öneriler ver. En fazla 3-5 adım olsun."
            }
        ],
        "temperature": 0.3,
        "stream": False
    }

    try:
        response = requests.post(API_URL, json=payload, headers={"Content-Type": "application/json"})
        result = response.json()

        if "choices" in result and len(result["choices"]) > 0:
            raw_suggestion = result["choices"][0]["message"]["content"]

            # <think> kısmını temizle
            if "<think>" in raw_suggestion:
                parts = raw_suggestion.split("</think>")
                suggestion = parts[-1].strip()
            else:
                suggestion = raw_suggestion.strip()
        else:
            suggestion = ""

    except Exception as e:
        print("Hata:", e)
        suggestion = ""

    return jsonify({"suggestion": suggestion})


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)