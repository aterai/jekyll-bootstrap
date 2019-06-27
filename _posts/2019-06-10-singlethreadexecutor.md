---
layout: post
category: swing
folder: SingleThreadExecutor
title: SwingWorkerを一スレッドづつ順番に実行する
tags: [SwingWorker, ExecutorService, JTable, JProgressBar]
author: aterai
pubdate: 2019-06-10T16:52:22+09:00
description: JTableのセルに配置したJProgressBarを操作するSwingWorkerタスクを一つづつ順番に実行します。
image: https://drive.google.com/uc?id=1x3PqH08NWiKXBFZl355XaqHN5fyc1zEdrg
comments: true
---
## 概要
`JTable`のセルに配置した`JProgressBar`を操作する`SwingWorker`タスクを一つづつ順番に実行します。

{% download https://drive.google.com/uc?id=1x3PqH08NWiKXBFZl355XaqHN5fyc1zEdrg %}

## サンプルコード
<pre class="prettyprint"><code>ExecutorService executor = Executors.newSingleThreadExecutor();
// ...
protected final void addActionPerformed() {
  int key = model.getRowCount();
  SwingWorker&lt;Integer, Integer&gt; worker = new BackgroundTask() {
    @Override protected void process(List&lt;Integer&gt; c) {
      if (isCancelled()) {
        return;
      }
      if (!isDisplayable()) {
        System.out.println("process: DISPOSE_ON_CLOSE");
        cancel(true);
        executor.shutdown();
        return;
      }
      c.forEach(v -&gt; model.setValueAt(v, key, 2));
    }
   @Override protected void done() {
      if (!isDisplayable()) {
        System.out.println("done: DISPOSE_ON_CLOSE");
        cancel(true);
        executor.shutdown();
        return;
      }
      String text;
      int i = -1;
      if (isCancelled()) {
        text = "Cancelled";
      } else {
        try {
          i = get();
          text = i &gt;= 0 ? "Done" : "Disposed";
        } catch (InterruptedException | ExecutionException ex) {
          text = ex.getMessage();
        }
      }
      System.out.format("%s:%s(%dms)%n", key, text, i);
      // executor.remove(this);
    }
  };
  model.addProgressValue("example", 0, worker);
  executor.execute(worker);
}
</code></pre>

## 解説
上記のサンプルでは、`Executors.newSingleThreadExecutor()`で作成した単一スレッド用の`executor`を使用して順番に一つづ`SwingWorker`を実行しています。

- - - -
- `Executors.newSingleThreadExecutor()`で生成される`ExecutorService`は、`Executors.newFixedThreadPool(1)`のものとほぼ同じ
    - [java - Difference between Executors.newFixedThreadPool(1) and Executors.newSingleThreadExecutor() - Stack Overflow](https://stackoverflow.com/questions/21300924/difference-between-executors-newfixedthreadpool1-and-executors-newsinglethread)
    - [Executors.newSingleThreadExecutor()が返すもの - torutkのブログ](https://torutk.hatenablog.jp/entry/20130824/p1)

<!-- dummy comment line for breaking list -->

- - - -
- デフォルトの`SwingWorker`は、`10`個のワーカ・スレッドを同時に実行可能
    - [Swing - Maximum number of SwingWorker objects in a Swing app?](https://community.oracle.com/thread/1364600)
        
        <pre class="prettyprint"><code>public abstract class SwingWorker&lt;T, V&gt; implements RunnableFuture&lt;T&gt; {
          /**
           * number of worker threads.
           */
          private static final int MAX_WORKER_THREADS = 10;
        // ...
        executorService =
            new ThreadPoolExecutor(MAX_WORKER_THREADS, MAX_WORKER_THREADS,
                                   10L, TimeUnit.MINUTES,
                                   new LinkedBlockingQueue&lt;Runnable&gt;(),
                                   threadFactory);
</code></pre>
    - * 参考リンク [#reference]
- [Executors#newSingleThreadExecutor() (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/java/util/concurrent/Executors.html#newSingleThreadExecutor--)
- [JTableのセルにJProgressBarを表示](https://ateraimemo.com/Swing/TableCellProgressBar.html)
- [&#91;JDK-6880336&#93; SwingWorker deadlocks due one thread in the swingworker-pool - Java Bug System](https://bugs.openjdk.java.net/browse/JDK-6880336)

<!-- dummy comment line for breaking list -->

## コメント
