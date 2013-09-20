---
layout: post
title: SwingWorkerを使った処理の中断と進捗状況表示
category: swing
folder: SwingWorker
tags: [SwingWorker, JProgressBar, JTextArea, Animation]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2006-06-10

## SwingWorkerを使った処理の中断と進捗状況表示
`JDK 6`で新しくなった`SwingWorker`を使って、処理の中断や進捗状況の表示更新などを行います。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTT8xXI-cI/AAAAAAAAAlQ/ueJc6P4EJVg/s800/SwingWorker.png)

### サンプルコード
<pre class="prettyprint"><code>class RunAction extends AbstractAction{
  public RunAction() {
    super("run");
  }
  @Override public void actionPerformed(ActionEvent evt) {
    //assert EventQueue.isDispatchThread();
    System.out.println("actionPerformed() is EDT?: "
        + EventQueue.isDispatchThread());
    final JProgressBar bar = new JProgressBar(0, 100);
    runButton.setEnabled(false);
    canButton.setEnabled(true);
    icon.animationStart();
    statusPanel.removeAll();
    statusPanel.add(bar);
    statusPanel.revalidate();
    bar.setIndeterminate(true);
    worker = new SwingWorker&lt;String, String&gt;() {
      @Override public String doInBackground() {
        System.out.println("doInBackground() is EDT?: "
            + EventQueue.isDispatchThread());
        try { // dummy task
          Thread.sleep(1000);
        }catch(InterruptedException ie) {
          return "Interrupted";
        }
        int current = 0;
        int lengthOfTask = 120; //list.size();
        publish("Length Of Task: " + lengthOfTask);
        publish("------------------------------");
        while(current&lt;lengthOfTask &amp;&amp; !isCancelled()) {
          try { // dummy task
            Thread.sleep(50);
          }catch(InterruptedException ie) {
            return "Interrupted";
          }
          setProgress(100 * current / lengthOfTask);
          //worker.firePropertyChange("progress", current, current+1);
          current++;
        }
        return "Done";
      }
      @Override protected void process(java.util.List&lt;String&gt; chunks) {
        //assert EventQueue.isDispatchThread();
        System.out.println("process() is EDT?: "
            + EventQueue.isDispatchThread());
        for(String message : chunks) {
          appendLine(message);
        }
      }
      @Override public void done() {
        //assert EventQueue.isDispatchThread();
        System.out.println("done() is EDT?: "
           + EventQueue.isDispatchThread());
        icon.animationStop();
        runButton.setEnabled(true);
        canButton.setEnabled(false);
        statusPanel.remove(bar);
        statusPanel.revalidate();
        String text = null;
        if(isCancelled()) {
          text = "Cancelled";
        }else{
          try {
            text = get();
          }catch(Exception ex) {
            ex.printStackTrace();
            text = "Exception";
          }
        }
        appendLine(text);
      }
    };
    worker.addPropertyChangeListener(new ProgressListener(bar));
    worker.execute();
  }
}

class CancelAction extends AbstractAction{
  public CancelAction() {
    super("cancel");
  }
  @Override public void actionPerformed(ActionEvent evt) {
    if(worker!=null &amp;&amp; !worker.isDone()) {
      worker.cancel(true);
    }
    worker = null;
  }
}
</code></pre>

### 解説
以前の`SwingWorker.java`から一部メソッド名が変更されていますが、基本的な使い方は一緒のようです。

- `SwingWorker#execute()`メソッドで処理が開始され、`SwingWorker#doInBackground()`メソッドが、バックグラウンドのスレッドで実行されます。
- `EDT`で実行する必要のある処理(上記の例では処理中に`JTextArea`へのメッセージの書き出し)は、`SwingWorker#process()`メソッドをオーバーライドして`SwingWorker#publish()`メソッドで呼び出したり、`SwingWorker#firePropertyChange()`を使えば良いようです。
- プログレスバーの処理には、`SwingWorker#setProgress(int)`が予め用意されているので、`SwingWorker#addPropertyChangeListener(ProgressListener)`を設定するだけで使用することが出来ます。
- 実行中の処理のキャンセルは、`SwingWorker#cancel(boolean)`メソッドで行います。キャンセルされたかどうかは、`SwingWorker#isCancelled()`メソッドで知ることが出来ます。

<!-- dummy comment line for breaking list -->

- - - -
`EventQueue.isDispatchThread()`を使うと以下のようになっています。

1. `actionPerformed() is EDT?`: `true`
1. `doInBackground() is EDT?`: `false`
    - ここ(バックグラウンド)で重い処理を行い、`EDT`を停止(ブロック)しないようにする

<!-- dummy comment line for breaking list -->
1. `process() is EDT?`: `true`
    - コンポーネントで進捗状況の表示を更新する場合は、`EDT`で行う必要があるので、ここ(`process()`メソッド内)で実行する

<!-- dummy comment line for breaking list -->
1. `done() is EDT?`: `true`

### 参考リンク
- [SwingWorker (Java Platform SE 6)](http://docs.oracle.com/javase/jp/6/api/javax/swing/SwingWorker.html)
- [Improve Application Performance With SwingWorker in Java SE 6](http://www.oracle.com/technetwork/articles/javase/swingworker-137249.html)
- [Worker Threads and SwingWorker](http://docs.oracle.com/javase/tutorial/uiswing/concurrency/worker.html)
- [JTableのセルにJProgressBarを表示](http://terai.xrea.jp/Swing/TableCellProgressBar.html)
- [SwingWorkerで複数のJProgressBarを使用する](http://terai.xrea.jp/Swing/TwoProgressBars.html)
- [SwingWorkerの一時停止と再開](http://terai.xrea.jp/Swing/PauseResumeSwingWorker.html)

<!-- dummy comment line for breaking list -->

### コメント
- ~~以前の`SwingWorker`の使い方などは、[Timerでアニメーションするアイコンを作成](http://terai.xrea.jp/Swing/AnimeIcon.html)、[Fileの再帰的検索](http://terai.xrea.jp/Swing/RecursiveFileSearch.html)などのソースコードやリンク先を参考にしてみてください。~~ -- [aterai](http://terai.xrea.jp/aterai.html) 2007-02-22 (木) 17:57:58
    - [Fileの再帰的検索](http://terai.xrea.jp/Swing/RecursiveFileSearch.html)は、`JDK 1.6`の`javax.swing.SwingWorker`を使用するように変更しました。
    - [Timerでアニメーションするアイコンを作成](http://terai.xrea.jp/Swing/AnimeIcon.html)は ~~https://swingworker.dev.java.net/ にある~~ `JDK 1.6`からバックポートされた`org.jdesktop.swingworker.SwingWorker`を使用するように変更しました。 -- [aterai](http://terai.xrea.jp/aterai.html) 2009-12-17 (木) 01:47:38
    - `java.net`が新しくなって結構時間が経ったけど、[http://java.net/projects/swingworker](http://java.net/projects/swingworker) から`jar`がダウンロードできない…。[maven2 のリポジトリ](http://download.java.net/maven/2/org/jdesktop/swing-worker/1.1/)から取得するしかない？  -- [aterai](http://terai.xrea.jp/aterai.html) 2011-12-02 (金) 17:23:45
    - 上記の`jar`は、`1.1`なので、`1.2`が必要なら、 ソースを取得して、`ant bundles` -- [aterai](http://terai.xrea.jp/aterai.html) 2011-12-02 (金) 17:38:31

<!-- dummy comment line for breaking list -->

