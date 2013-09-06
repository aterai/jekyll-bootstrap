---
layout: post
title: JTextAreaから一行ずつ文字列を取得
category: swing
folder: GetLineText
tags: [JTextArea, StringTokenizer, LineNumberReader]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2006-10-09

## JTextAreaから一行ずつ文字列を取得
`JTextArea`などのテキストコンポーネントから一行ずつ文字列を取り出してそれを処理します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTNWn74dWI/AAAAAAAAAao/pNdeF8CSOfM/s800/GetLineText.png)

### サンプルコード
<pre class="prettyprint"><code>int count = 0;
StringTokenizer st = new StringTokenizer(textArea.getText(), "\n") ;
while(st.hasMoreTokens()) {
  if(st.nextToken().startsWith("#")) {
    count++;
  }
}
</code></pre>

### 解説
上記のサンプルでは、`JTextArea#getText()`ですべてのテキストを取得し、`StringTokenizer`を使って行毎に分解しています。

- - - -
- `String#split`を使用する場合

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>for(String line: textArea.getText().split("\\n")) {
  if(line.startsWith("#")) {
    count++;
  }
}
</code></pre>

- `LineNumberReader`を使用する場合

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>try(LineNumberReader lnr = new LineNumberReader(new StringReader(textArea.getText()))) {
  String line = null;
  while((line = lnr.readLine()) != null) {
    if(line.startsWith("#")) {
      count++;
    }
  }
}catch(IOException ioe) {
  ioe.printStackTrace();
}
</code></pre>

- `Element#getElementCount`を使用する場合

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>Document doc = textArea.getDocument();
Element root = doc.getDefaultRootElement();
try{
  for(int i=0;i&lt;root.getElementCount();i++) {
    Element elem = root.getElement(i);
    String line = doc.getText(elem.getStartOffset(), elem.getEndOffset()-elem.getStartOffset());
    if(line.startsWith("#")) {
      count++;
    }
  }
}catch(BadLocationException ble) {
  ble.printStackTrace();
}
</code></pre>

### コメント
