---
layout: post
category: swing
folder: SelectWordAction
title: JTextAreaで単語選択を実行した場合の区切り文字を変更する
tags: [JTextArea, Segment, Document]
author: aterai
pubdate: 2016-05-09T00:37:01+09:00
description: JTextAreaで文字列のダブルクリックによる単語選択を実行した場合、単語の区切りとみなす文字を追加します。
image: https://lh3.googleusercontent.com/-FkLFDSXe14A/Vy9ZM9GU81I/AAAAAAAAOUE/RMwBLf19Nb0uXaKdI9VA3l3wvXSOegS6gCCo/s800/SelectWordAction.png
comments: true
---
## 概要
`JTextArea`で文字列のダブルクリックによる単語選択を実行した場合、単語の区切りとみなす文字を追加します。

{% download https://lh3.googleusercontent.com/-FkLFDSXe14A/Vy9ZM9GU81I/AAAAAAAAOUE/RMwBLf19Nb0uXaKdI9VA3l3wvXSOegS6gCCo/s800/SelectWordAction.png %}

## サンプルコード
<pre class="prettyprint"><code>//@see javax.swint.text.Utilities.getWordStart(...)
int getWordStart(JTextComponent c, int offs) throws BadLocationException {
  Element line = Optional.ofNullable(Utilities.getParagraphElement(c, offs))
                         .orElseThrow(() -&gt; new BadLocationException("No word at " + offs, offs));
  Document doc = c.getDocument();
  int lineStart = line.getStartOffset();
  int lineEnd = Math.min(line.getEndOffset(), doc.getLength());
  int offs2 = offs;
  Segment seg = SegmentCache.getSharedSegment();
  doc.getText(lineStart, lineEnd - lineStart, seg);
  if (seg.count &gt; 0) {
    BreakIterator words = BreakIterator.getWordInstance(c.getLocale());
    words.setText(seg);
    int wordPosition = seg.offset + offs - lineStart;
    if (wordPosition &gt;= words.last()) {
      wordPosition = words.last() - 1;
      words.following(wordPosition);
      offs2 = lineStart + words.previous() - seg.offset;
    } else {
      words.following(wordPosition);
      offs2 = lineStart + words.previous() - seg.offset;
      for (int i = offs; i &gt; offs2; i--) {
        char ch = seg.charAt(i - seg.offset);
        if (ch == '_' || ch == '-') {
          offs2 = i + 1;
          break;
        }
      }
    }
  }
  SegmentCache.releaseSharedSegment(seg);
  return offs2;
}
</code></pre>

## 解説
上記のサンプルでは、`JTextArea`で文字列をダブルクリックした場合に実行される単語選択アクション(`new TextAction(DefaultEditorKit.selectWordAction)`)を変更し、常に`_`、`-`記号で単語を区切るように設定しています。

- `Default`
    - `_`、`-`は、単語区切りにならず、`AA-BB_CC`は一つの単語として選択される
    - 単語選択アクションは、クリックした位置から単語の先頭と末尾を探す方法として`javax.swint.text.Utilities`の`getWordEnd(...)`と`getWordEnd(...)`メソッドを使用している
- `Break words: _ and -`
    - `_`と`-`を単語区切りに追加し、`AA-BB_CC`の`BB`上でダブルクリックすると`BB`のみ選択されるよう変更
    - `javax.swint.text.Utilities`の`getWordEnd(...)`と`getWordEnd(...)`メソッドをコピーし、`BreakIterator.getWordInstance(c.getLocale())`で見つけた単語内に`_`か`-`が存在するか再度検索するよう改変

<!-- dummy comment line for breaking list -->

## 参考リンク
- [Utilities#getWordEnd(...) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/text/Utilities.html#getWordEnd-javax.swing.text.JTextComponent-int-)
- [JTextAreaのCaretを変更してマウスのダブルクリックによる単語選択の動作を変更する](https://ateraimemo.com/Swing/ContinuouslySelectWords.html)

<!-- dummy comment line for breaking list -->

## コメント
