---
layout: post
category: swing
folder: SwingWorker
title: SwingWorkerを使った処理の中断と進捗状況表示
tags: [SwingWorker, JProgressBar, JTextArea, Animation]
author: aterai
pubdate: 2006-06-10T11:46:45+09:00
description: JDK 6で新しくなったSwingWorkerを使って、処理の中断や進捗状況の表示更新などを行います。
image: https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTT8xXI-cI/AAAAAAAAAlQ/ueJc6P4EJVg/s800/SwingWorker.png
comments: true
---
## 概要
`JDK 6`で新しくなった`SwingWorker`を使って、処理の中断や進捗状況の表示更新などを行います。

{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTT8xXI-cI/AAAAAAAAAlQ/ueJc6P4EJVg/s800/SwingWorker.png %}

## サンプルコード
<pre class="prettyprint"><code>class Task extends SwingWorker&lt;String, String&gt; {
  @Override public String doInBackground() {
    System.out.println("doInBackground() is EDT?: " + EventQueue.isDispatchThread());
    try {
      Thread.sleep(1000);
    } catch (InterruptedException ie) {
      return "Interrupted";
    }
    int current = 0;
    int lengthOfTask = 120; //list.size();
    publish("Length Of Task: " + lengthOfTask);
    publish("\n------------------------------\n");

    while (current &lt; lengthOfTask &amp;&amp; !isCancelled()) {
      try {
        Thread.sleep(50); //doSomething(file = list(current));
      } catch (InterruptedException ie) {
        return "Interrupted";
      }
      setProgress(100 * current / lengthOfTask);
      publish(".");
      current++;
    }
    publish("\n");
    return "Done";
  }
}

class RunAction extends AbstractAction {
  public RunAction() {
    super("run");
  }
  @Override public void actionPerformed(ActionEvent evt) {
    System.out.println("actionPerformed() is EDT?: " + EventQueue.isDispatchThread());
    final JProgressBar bar = new JProgressBar();
    runButton.setEnabled(false);
    canButton.setEnabled(true);
    anil.startAnimation();
    statusPanel.removeAll();
    statusPanel.add(bar);
    statusPanel.revalidate();
    bar.setIndeterminate(true);

    worker = new Task() {
      @Override protected void process(List&lt;String&gt; chunks) {
        System.out.println("process() is EDT?: " + EventQueue.isDispatchThread());
        if (!isDisplayable()) {
          System.out.println("process: DISPOSE_ON_CLOSE");
          cancel(true);
          return;
        }
        for (String message : chunks) {
          appendText(message);
        }
      }
      @Override public void done() {
        System.out.println("done() is EDT?: " + EventQueue.isDispatchThread());
        if (!isDisplayable()) {
          System.out.println("done: DISPOSE_ON_CLOSE");
          cancel(true);
          return;
        }
        anil.stopAnimation();
        runButton.setEnabled(true);
        canButton.setEnabled(false);
        statusPanel.remove(bar);
        statusPanel.revalidate();
        String text = null;
        if (isCancelled()) {
          text = "Cancelled";
        } else {
          try {
            text = get();
          } catch (InterruptedException | ExecutionException ex) {
            ex.printStackTrace();
            text = "Exception";
          }
        }
        appendText(text);
      }
    };
    worker.addPropertyChangeListener(new ProgressListener(bar));
    worker.execute();
  }
}

class CancelAction extends AbstractAction {
  public CancelAction() {
    super("cancel");
  }
  @Override public void actionPerformed(ActionEvent evt) {
    if (worker != null &amp;&amp; !worker.isDone()) {
      worker.cancel(true);
    }
    worker = null;
  }
}
</code></pre>

## 解説
`JDK 6`以前の`SwingWorker.java`から一部メソッド名が変更されていますが、基本的な使い方は一緒のようです。

- `SwingWorker#execute()`メソッドで処理が開始され、`SwingWorker#doInBackground()`メソッドが、バックグラウンドのワーカースレッドで実行される
- `EDT`で実行する必要のある処理(上記の例では処理中に`JTextArea`へのメッセージの書き出し)は、`SwingWorker#process()`メソッドをオーバーライドして`SwingWorker#publish()`メソッドで呼び出したり、`SwingWorker#firePropertyChange()`を使用する
- プログレスバーの処理には、`SwingWorker#setProgress(int)`が予め用意されているので、`SwingWorker#addPropertyChangeListener(ProgressListener)`を設定するだけで使用することが可能
- `SwingWorker#setProgress(int)`で設定できるのは`0`から`100`で固定
    
    <pre class="prettyprint"><code>protected final void setProgress(int progress) {
      if (progress &lt; 0 || progress &gt; 100) {
        throw new IllegalArgumentException("the value should be from 0 to 100");
      }
    //...
</code></pre>
- 実行中の処理のキャンセルは、`SwingWorker#cancel(boolean)`メソッドで行います。キャンセルされたかどうかは、`SwingWorker#isCancelled()`メソッドで判定可能

<!-- dummy comment line for breaking list -->

- - - -
現在のスレッドがイベントディスパッチスレッド(以下`EDT`)かどうかを調べる`EventQueue.isDispatchThread()`を、このサンプルで使用すると以下のようになります。

1. `actionPerformed() is EDT?`: `true`
    - 現在のスレッド(このサンプルでは`EDT`)で、ボタンを選択不可にしたり、`SwingWorker#execute()`を実行している

<!-- dummy comment line for breaking list -->
1. `doInBackground() is EDT?`: `false`
    - ワーカースレッド(バックグラウンド)で重い処理を行い、`EDT`をブロックして停止状態にならないようにする

<!-- dummy comment line for breaking list -->
1. `process() is EDT?`: `true`
1. `done() is EDT?`: `true`
    - `Swing`関連のすべての作業(例えば`JProgressBar`の進捗表示更新)は、`EDT`で行う必要があるので、`process()`か`done()`メソッド内で実行する

<!-- dummy comment line for breaking list -->

- - - -
`SwingWorker#process()`メソッド内などで`JPanel#sDisplayable()`を呼び、アプリケーション(`frame.setDefaultCloseOperation(WindowConstants.DISPOSE_ON_CLOSE);`が設定されている)が終了している場合は、タスクを中断することで`SwingWorker`が生き残るのを防止しています。

## 参考リンク
- [SwingWorker (Java Platform SE 6)](http://docs.oracle.com/javase/jp/6/api/javax/swing/SwingWorker.html)
- [Improve Application Performance With SwingWorker in Java SE 6](http://www.oracle.com/technetwork/articles/javase/swingworker-137249.html)
- [Worker Threads and SwingWorker](http://docs.oracle.com/javase/tutorial/uiswing/concurrency/worker.html)
- [JTableのセルにJProgressBarを表示](http://ateraimemo.com/Swing/TableCellProgressBar.html)
- [SwingWorkerで複数のJProgressBarを使用する](http://ateraimemo.com/Swing/TwoProgressBars.html)
- [SwingWorkerの一時停止と再開](http://ateraimemo.com/Swing/PauseResumeSwingWorker.html)

<!-- dummy comment line for breaking list -->

## コメント
- ~~以前の`SwingWorker`の使い方などは、[Timerでアニメーションするアイコンを作成](http://ateraimemo.com/Swing/AnimeIcon.html)、[Fileの再帰的検索](http://ateraimemo.com/Swing/RecursiveFileSearch.html)などのソースコードやリンク先を参考にしてみてください。~~ [Fileの再帰的検索](http://ateraimemo.com/Swing/RecursiveFileSearch.html)は、`JDK 1.6`の`javax.swing.SwingWorker`を使用するように変更しました。 -- *aterai* 2007-02-22 (木) 17:57:58
    - [Timerでアニメーションするアイコンを作成](http://ateraimemo.com/Swing/AnimeIcon.html)は ~~https://swingworker.dev.java.net/ にある~~ `JDK 1.6`からバックポートされた`org.jdesktop.swingworker.SwingWorker`を使用するように変更しました。 -- *aterai* 2009-12-17 (木) 01:47:38
    - `java.net`が新しくなって結構時間が経ったけど、[http://java.net/projects/swingworker](http://java.net/projects/swingworker) から`jar`がダウンロードできない…。[maven2 のリポジトリ](http://download.java.net/maven/2/org/jdesktop/swing-worker/1.1/)から取得するしかない？  -- *aterai* 2011-12-02 (金) 17:23:45
    - 上記の`jar`は、`1.1`なので、`1.2`が必要なら、 ソースを取得して、`ant bundles` -- *aterai* 2011-12-02 (金) 17:38:31

<!-- dummy comment line for breaking list -->
