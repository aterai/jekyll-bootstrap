---
layout: post
category: swing
folder: TextAreaOutputStream
title: JTextAreaにLoggerのログを出力する
tags: [JTextArea, OutputStream, StreamHandler, Logger]
author: aterai
pubdate: 2015-02-16T00:00:51+09:00
description: Loggerのログ出力をJTextAreaに表示するためのOutputStreamとStreamHandlerを作成します。
hreflang:
    href: http://java-swing-tips.blogspot.com/2015/02/logging-into-jtextarea.html
    lang: en
comments: true
---
## 概要
`Logger`のログ出力を`JTextArea`に表示するための`OutputStream`と`StreamHandler`を作成します。

{% download https://lh3.googleusercontent.com/-SjJO0dTl1jg/VOChTiK0lPI/AAAAAAAANw4/elD2Gb4uBd0/s800/TextAreaOutputStream.png %}

## サンプルコード
<pre class="prettyprint"><code>class TextAreaOutputStream extends OutputStream {
  private final ByteArrayOutputStream buf = new ByteArrayOutputStream();
  private final JTextArea textArea;
  public TextAreaOutputStream(JTextArea textArea) {
    super();
    this.textArea = textArea;
  }
  @Override public void flush() throws IOException {
    textArea.append(buf.toString("UTF-8"));
    buf.reset();
  }
  @Override public void write(int b) throws IOException {
    buf.write(b);
  }
}
</code></pre>

## 解説
- `TextAreaOutputStream`
    - `ByteArrayOutputStream`を使用して、`JTextArea`に一行ずつ書き込みを行う
    - これを`System.setOut(new PrintStream(new TextAreaOutputStream(textArea), true, "UTF-8"));`のように標準出力ストリームに割り当てると、`System.out.printlen("xxxxx")`などで改行文字が書き込まれたときに、バッファーの`flush()`が呼び出され、`textArea.append(buf.toString("UTF-8"));`で`JTextArea`に文字列が追記される
- `TextAreaHandler`
    - ログ出力を上記の`TextAreaOutputStream`などに割り当てるため、`StreamHandler`を継承する`TextAreaHandler`を作成し、`Logger#addHandler(...)`で設定
    - `StreamHandler#setEncoding(...)`でエンコーディングを`UTF-8`に設定
    - `StreamHandler#publish(...)`、`StreamHandler#close(...)`をオーバーライド

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>class TextAreaHandler extends StreamHandler {
  private void configure() {
    setFormatter(new SimpleFormatter());
    try {
      setEncoding("UTF-8");
    } catch (IOException ex) {
      try {
        setEncoding(null);
      } catch (IOException ex2) {
        // doing a setEncoding with null should always work.
        // assert false;
        ex2.printStackTrace();
      }
    }
  }
  public TextAreaHandler(OutputStream os) {
    super();
    configure();
    setOutputStream(os);
  }
  //@see java/util/logging/ConsoleHandler.java
  @Override public void publish(LogRecord record) {
    super.publish(record);
    flush();
  }
  @Override public void close() {
    flush();
  }
}
</code></pre>

## 参考リンク
- [System.out.println() Print to JFrame | Oracle Community](https://community.oracle.com/thread/1366824)
- [External Program Output To JTextArea - Java | Dream.In.Code](http://www.dreamincode.net/forums/topic/117537-external-program-output-to-jtextarea/)
- [標準出力を JTextArea に出力する - As I like it.](http://d.hatena.ne.jp/altcla/20091029/1256824750)
- [Message Console « Java Tips Weblog](https://tips4java.wordpress.com/2008/11/08/message-console/)

<!-- dummy comment line for breaking list -->

## コメント
