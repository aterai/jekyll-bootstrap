---
layout: post
category: swing
folder: FileChooserMultiSelection
title: JFileChooserで複数ファイルの選択を行う
tags: [JFileChooser]
author: aterai
pubdate: 2017-04-17T14:42:10+09:00
description: JFileChooserで複数ファイルの選択ができるように設定します。
image: https://drive.google.com/uc?export=view&id=1-cun-rfsw3qiGmb6K8Fp5hlrAArduvrQHw
comments: true
---
## 概要
`JFileChooser`で複数ファイルの選択ができるように設定します。

{% download https://drive.google.com/uc?export=view&id=1-cun-rfsw3qiGmb6K8Fp5hlrAArduvrQHw %}

## サンプルコード
<pre class="prettyprint"><code>JFileChooser fileChooser = new JFileChooser();
//fileChooser.setFileSelectionMode(JFileChooser.FILES_ONLY);
//fileChooser.setFileSelectionMode(JFileChooser.DIRECTORIES_ONLY);
//fileChooser.setFileSelectionMode(JFileChooser.FILES_AND_DIRECTORIES);
fileChooser.setMultiSelectionEnabled(true);
int retvalue = fileChooser.showOpenDialog(getRootPane());
if (retvalue == JFileChooser.APPROVE_OPTION) {
  log.setText("");
  for (File file: fileChooser.getSelectedFiles()) {
    log.append(file.getAbsolutePath() + "\n");
  }
}
</code></pre>

## 解説
- `Default`
    - `JFileChooser`のデフォルトは、複数ファイル選択不可
- `setMultiSelectionEnabled(true)`
    - [JFileChooser#setMultiSelectionEnabled(boolean)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JFileChooser.html#setMultiSelectionEnabled-boolean-)メソッドを使用して、複数ファイル選択を可能に設定
    - 複数選択したファイルは、[JFileChooser##getSelectedFiles()](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JFileChooser.html#getSelectedFiles--)で取得可能
        - 未選択の場合は、`null`ではなく空のファイル配列(`new File[0]`)が返り値になるが、開くボタンをクリックしても`JFileChooser`は閉じない
    - デフォルトの`FileSelectionMode`は、`JFileChooser.FILES_ONLY`なので、<kbd>Ctrl+A</kbd>でファイルのみが選択される
        - `JFileChooser.FILES_ONLY`でもファイルが未選択の場合は、<kbd>Ctrl</kbd>+マウスクリックでディレクトリが複数選択できてしまう？

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JFileChooser (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JFileChooser.html#setMultiSelectionEnabled-boolean-)

<!-- dummy comment line for breaking list -->

## コメント
