---
layout: post
category: swing
folder: GetLineText
title: JTextAreaから一行ずつ文字列を取得
tags: [JTextArea, StringTokenizer, LineNumberReader]
author: aterai
pubdate: 2006-10-09T22:13:19+09:00
description: JTextAreaなどのテキストコンポーネントから一行ずつ文字列を取り出してそれを処理します。
image: https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTNWn74dWI/AAAAAAAAAao/pNdeF8CSOfM/s800/GetLineText.png
comments: true
---
## 概要
`JTextArea`などのテキストコンポーネントから一行ずつ文字列を取り出してそれを処理します。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTNWn74dWI/AAAAAAAAAao/pNdeF8CSOfM/s800/GetLineText.png %}

## サンプルコード
<pre class="prettyprint"><code>int count = 0;
StringTokenizer st = new StringTokenizer(textArea.getText(), "\n");
while (st.hasMoreTokens()) {
  if (st.nextToken().codePointAt(0) == '#') {
    count++;
  }
}
</code></pre>

## 解説
上記のサンプルでは、`JTextArea#getText()`ですべてのテキストを取得し、`StringTokenizer`を使って行毎に分解しています。`returnDelims`フラグが`false`なので、トークンが空行になることはありません。

- - - -
- `String#split(...)`を使用する場合
    - 空行あり

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>for (String line: textArea.getText().split("\\n")) {
  if (!line.isEmpty() &amp;&amp; line.codePointAt(0) == '#') {
    count++;
  }
}
</code></pre>

- `LineNumberReader`を使用する場合
    - 空行あり

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>try (LineNumberReader lnr = new LineNumberReader(new StringReader(textArea.getText()))) {
  String line = null;
  while ((line = lnr.readLine()) != null) {
    if (!line.isEmpty() &amp;&amp; line.codePointAt(0) == '#') {
      count++;
    }
  }
} catch (IOException ioe) {
  ioe.printStackTrace();
}
</code></pre>

- `Element#getElementCount()`を使用する場合
    - 空行なし(`Element`には少なくとも長さ`1`の改行が存在する)

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>Document doc = textArea.getDocument();
Element root = doc.getDefaultRootElement();
try {
  for (int i = 0; i &lt; root.getElementCount(); i++) {
    Element elm = root.getElement(i);
    String line = doc.getText(elm.getStartOffset(), elm.getEndOffset() - elm.getStartOffset());
    if (line.codePointAt(0) == '#') {
      count++;
    }
  }
} catch (BadLocationException ble) {
  ble.printStackTrace();
}
</code></pre>

## 参考リンク
- [StringTokenizer (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/java/util/StringTokenizer.html)
- [LineNumberReader (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/java/io/LineNumberReader.html)
- [Element#getElementCount() (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/text/Element.html#getElementCount--)

<!-- dummy comment line for breaking list -->

## コメント
