---
layout: post
title: ProgressMonitorInputStreamを使用してテキストファイルのダウンロード状況を表示
category: swing
folder: ProgressMonitorInputStream
tags: [ProgressMonitorInputStream, ProgressMonitor, JProgressBar, SwingWorker, URLConnection, JTextArea]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2013-04-22

## ProgressMonitorInputStreamを使用してテキストファイルのダウンロード状況を表示
`ProgressMonitorInputStream`を使用してテキストファイルのダウンロード状態を進捗表示します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh4.googleusercontent.com/-gXnU23f7iiw/UXQuzmKdfVI/AAAAAAAABp8/aPk0QR78NlY/s800/ProgressMonitorInputStream.png)

### サンプルコード
<pre class="prettyprint"><code>worker = new SwingWorker&lt;String, Chunk&gt;() {
  @Override public String doInBackground() {
    Charset cs = Charset.forName("EUC-JP");
    String ret = "Done";
    String path = "http://terai.xrea.jp/";
    URLConnection urlConnection;
    try{
      urlConnection = new URL(path).openConnection();
      System.out.println(urlConnection.getContentEncoding());
      System.out.println(urlConnection.getContentType());

      String encoding = urlConnection.getContentEncoding();
      if(encoding!=null) {
        cs = Charset.forName(encoding);
      }else{
        String contentType = urlConnection.getContentType();
        for(String value: contentType.split(";")) {
          value = value.trim();
          if(value.toLowerCase().startsWith("charset=")) {
            encoding = value.substring("charset=".length());
          }
        }
        if(encoding!=null) {
          cs = Charset.forName(encoding);
        }
      }
      System.out.println(cs);
    }catch(Exception ex) {
      ex.printStackTrace();
      ret = "Error";
      return ret;
    }
    int length = urlConnection.getContentLength();
    try(InputStream is = urlConnection.getInputStream();
        ProgressMonitorInputStream pmis = new ProgressMonitorInputStream(frame, "Loading", is);
        BufferedReader reader = new BufferedReader(new InputStreamReader(pmis, cs))) {

      monitor = pmis.getProgressMonitor();
      monitor.setNote(" "); //Need for JLabel#getPreferredSize
      monitor.setMillisToDecideToPopup(0);
      monitor.setMillisToPopup(0);
      monitor.setMinimum(0);
      monitor.setMaximum(length);

      int i = 0;
      int size = 0;
      String line;
      while((line = reader.readLine()) != null) {
        if(i++%50==0) { //Wait
          Thread.sleep(10);
        }
        size += line.getBytes(cs).length + 1; //+1: \n
        String note = String.format("%03d%% - %d/%d%n", 100*size/length, size, length);
        publish(new Chunk(line, note));
      }
    }catch(InterruptedException | IOException ex) {
      ret = "Exception";
      cancel(true);
    }
    return ret;
  }
  @Override protected void process(List&lt;Chunk&gt; chunks) {
    for(Chunk c: chunks) {
      textArea.append(c.line+"\n");
      monitor.setNote(c.note);
      //System.out.println(c.note);
    }
    textArea.setCaretPosition(textArea.getDocument().getLength());
  }
  @Override public void done() {
    frame.getGlassPane().setVisible(false);
    runButton.setEnabled(true);
    String text = null;
    try{
      text = isCancelled() ? "Cancelled" : get();
    }catch(Exception ex) {
      ex.printStackTrace();
      text = "Exception";
    }
    System.out.println(text);
  }
};
worker.execute();
</code></pre>

### 解説
上記のサンプルでは、`URLConnection`から開いた`InputStream`に`ProgressMonitorInputStream`をラップして、ファイルのダウンロード進捗状態を`ProgressMonitor`で表示しています。

- `ProgressMonitorInputStream`の使用する`ProgressMonitor`の最大値は、ファイルサイズ(バイト)
    - `ProgressMonitorInputStream`がデフォルトで設定する最大値は、`InputStream#available()`の値
    - この値がダウンロード中のストリームの合計バイト数を返す訳ではないので、これを最大値のままにしておくと、`ProgressMonitor`が表示されない、またはすぐ閉じてしまう
    - `URLConnection#getContentLength()`で取得したバイト数を`ProgressMonitor#setMaximum(...)`で設定
- 一行ずつ`JTextArea`に文字列として読み込ませるために、`InputStreamReader`を使用しているので、エンコードを`URLConnection#getContentEncoding()`や`URLConnection#getContentType()`などで取得
    - 何パーセント読み込んだかを`ProgressMonitor#setNote(...)`で表示する場合は、一行が何バイトかを`String#getBytes(Charset)`で取得して計算
    - 注: 改行は`1`バイトで決め打ちしている
    - 進捗を表示する前に`ProgressMonitor#setNote("dummy note");`としておかないと、`Note`に使用する`JLabel`が`null`のままで表示されない、またはレイアウトがおかしくなる

<!-- dummy comment line for breaking list -->

### 参考リンク
- [ProgressMonitorがダイアログを表示するまでの待ち時間](http://terai.xrea.jp/Swing/MillisToDecideToPopup.html)

<!-- dummy comment line for breaking list -->

### コメント
