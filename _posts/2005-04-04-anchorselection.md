---
layout: post
title: JTableのセルにあるフォーカスを解除
category: swing
folder: AnchorSelection
nofollow: true
comments: true
---

Posted by [](http://terai.xrea.jp/.html) at 2005-04-04

## 概要
以下のコメントにあるように、`Java 6`以降でソートや`clearSelection`すれば、選択状態やフォーカスは解除されるようになりました。このサンプルは意味が無くなったので削除し、代わりに`JTableHeader`をクリックした場合の例を[JTableHeaderをクリックしてそのColumnのセルを全選択](http://terai.xrea.jp/Swing/ColumnSelection.html)に作成しました。

## コメント
- `JDK 1.5.0_06`などにして試してみたところ、特別なことをしなくてもヘッダをクリックしてソートするとセルのフォーカスは外れるようです。 -- [aterai](http://terai.xrea.jp/aterai.html) 2006-01-13 (金) 16:07:44
    - もう修正されているようなので、この記事は削除するか、別の内容に変更するかもしれません。[Bug ID: JDK-6195469 REGRESSION: Multiple interval selection is lost in JTable if mouse is dragged](http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=6195469) -- [aterai](http://terai.xrea.jp/aterai.html) 2006-04-19 (水) 22:04:07
- 移動したときに、日本語入力するには、どうしたらいいんですかね？ -- [zero](http://terai.xrea.jp/zero.html) 2006-03-09 (木) 20:19:17
- 多分エクセルみたいな入力のことですよね。アルファベットならマウスで入力状態にしなくてもフォーカスがあるセルに直接入力できますが、`IME`が`on`の日本語入力モードの場合はうまくいかないようです。いまのところこれを簡単に行う方法を僕は知らないです。 -- [aterai](http://terai.xrea.jp/aterai.html) 2006-03-09 (木) 23:09:26
