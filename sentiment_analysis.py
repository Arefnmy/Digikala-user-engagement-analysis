import os
import pandas as pd
import torch
from transformers import AutoTokenizer, AutoModelForSequenceClassification
from torch.utils.data import DataLoader, Dataset
import logging
from tqdm import tqdm

# Set up logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class CommentDataset(Dataset):
    def __init__(self, texts, tokenizer, max_len):
        self.texts = texts
        self.tokenizer = tokenizer
        self.max_len = max_len

    def __len__(self):
        return len(self.texts)

    def __getitem__(self, idx):
        text = str(self.texts[idx])
        inputs = self.tokenizer.encode_plus(
            text,
            None,
            add_special_tokens=True,
            max_length=self.max_len,
            padding='max_length',
            return_token_type_ids=False,
            truncation=True
        )
        return {
            'input_ids': torch.tensor(inputs['input_ids'], dtype=torch.long),
            'attention_mask': torch.tensor(inputs['attention_mask'], dtype=torch.long),
        }

def analyze_sentiment_batch(model, data_loader, device):
    model.eval()
    model.to(device)

    labels = []
    confidences = []

    with torch.no_grad():
        for i, batch in enumerate(tqdm(data_loader, desc="Processing batches")):
            input_ids = batch['input_ids'].to(device)
            attention_mask = batch['attention_mask'].to(device)

            outputs = model(input_ids=input_ids, attention_mask=attention_mask)
            probs = torch.nn.functional.softmax(outputs.logits, dim=-1)
            confidence, label_id = torch.max(probs, dim=1)
            label = ['negative' if x == 1 else 'positive' for x in label_id.cpu().numpy()]

            labels.extend(label)
            confidences.extend(confidence.cpu().numpy())

            if i % 100 == 0:
                logger.info(f"Processed {i * len(batch['input_ids'])} comments")

    return labels, confidences

def load_model(model_name, local_dir):
    if os.path.exists(local_dir):
        logger.info(f"Loading model from local directory: {local_dir}")
        model = AutoModelForSequenceClassification.from_pretrained(local_dir)
        tokenizer = AutoTokenizer.from_pretrained(local_dir)
    else:
        logger.info(f"Downloading and saving model to local directory: {local_dir}")
        tokenizer = AutoTokenizer.from_pretrained(model_name)
        model = AutoModelForSequenceClassification.from_pretrained(model_name)
        os.makedirs(local_dir, exist_ok=True)
        tokenizer.save_pretrained(local_dir)
        model.save_pretrained(local_dir)
    return tokenizer, model

def main():
    # Load the CSV file
    file_path = 'comments.csv'  # Update with the correct path to your file
    df = pd.read_csv(file_path)

    # Ensure all comments are strings
    df['body'] = df['body'].astype(str)

    # Model parameters
    model_name = "HooshvareLab/bert-fa-base-uncased-sentiment-digikala"
    local_dir = "C:\\Users\\Sina\\Desktop\\ToDel\\local_model_cache"
    batch_size = 32  # Adjust according to your GPU memory
    max_len = 128
    device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')

    # Load model and tokenizer
    tokenizer, model = load_model(model_name, local_dir)

    # Create dataset and dataloader
    dataset = CommentDataset(df['body'].tolist(), tokenizer, max_len)
    data_loader = DataLoader(dataset, batch_size=batch_size, shuffle=False)

    # Perform sentiment analysis in batches
    logger.info("Starting sentiment analysis")
    labels, confidences = analyze_sentiment_batch(model, data_loader, device)
    df['label'] = labels
    df['confidence'] = confidences

    # Save the updated DataFrame
    output_path = 'results.csv'  # Update with the desired output path
    df.to_csv(output_path, index=False)

    logger.info(f"Updated DataFrame saved to {output_path}")

if __name__ == "__main__":
    main()