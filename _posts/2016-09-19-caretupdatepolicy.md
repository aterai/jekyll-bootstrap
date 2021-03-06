---
layout: post
category: swing
folder: CaretUpdatePolicy
title: JTextAreaでドキュメント更新時のCaret移動をテストする
tags: [JTextArea, DefaultCaret, JTextComponent, JScrollPane]
author: aterai
pubdate: 2016-09-19T15:50:56+09:00
description: JTextAreaのドキュメントが更新された時、Caretのアップデートポリシーによって、その位置がどのように移動するかをテストします。
image: https://drive.google.com/uc?id=1lEAsdjscriBkK232QDUjR95IJEIuxvnTQg
comments: true
---
## 概要
`JTextArea`のドキュメントが更新された時、`Caret`のアップデートポリシーによって、その位置がどのように移動するかをテストします。

{% download https://drive.google.com/uc?id=1lEAsdjscriBkK232QDUjR95IJEIuxvnTQg %}

## サンプルコード
<pre class="prettyprint"><code>((DefaultCaret) ta0.getCaret()).setUpdatePolicy(DefaultCaret.UPDATE_WHEN_ON_EDT); // default
((DefaultCaret) ta1.getCaret()).setUpdatePolicy(DefaultCaret.ALWAYS_UPDATE);
((DefaultCaret) ta2.getCaret()).setUpdatePolicy(DefaultCaret.NEVER_UPDATE);
</code></pre>

## 解説
- [DefaultCaret.UPDATE_WHEN_ON_EDT](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/text/DefaultCaret.html#UPDATE_WHEN_ON_EDT)
    - デフォルト
    - `EDT`(イベント・ディスパッチ・スレッド)でドキュメントの変更が行われる場合にのみ、`Caret`位置が更新される
    - このサンプルでは、`On EDT`がチェックされている場合、`SwingWorker#process(...)`内でドキュメントが変更される
    - このため、`Caret`が末尾にあるとその位置が移動するので、左と中の`JTextArea`でスクロールが発生する
- [DefaultCaret.ALWAYS_UPDATE](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/text/DefaultCaret.html#ALWAYS_UPDATE)
    - ドキュメントの更新が`EDT`で行われるかどうかに関係なく、`Caret`位置が必ず更新される
    - このサンプルでは、`On EDT`がチェックされていない場合、`SwingWorker#doInBackground(...)`内でドキュメントが変更される
    - このため、`Caret`が末尾にあるとその位置が移動するので、この`JTextArea`でのみスクロールが発生する
- [DefaultCaret.NEVER_UPDATE](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/text/DefaultCaret.html#NEVER_UPDATE)
    - ドキュメントが更新されても、ドキュメント内のキャレットの絶対位置は移動しない
        - テキストが削除されて、ドキュメントの長さが現在のキャレット位置よりも短くなる場合は除く

<!-- dummy comment line for breaking list -->

## 参考リンク
- [DefaultCaret (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/text/DefaultCaret.html)
- [The Event Dispatch Thread (The Java™ Tutorials > Creating a GUI With JFC/Swing > Concurrency in Swing)](https://docs.oracle.com/javase/tutorial/uiswing/concurrency/dispatch.html)

<!-- dummy comment line for breaking list -->

## コメント
