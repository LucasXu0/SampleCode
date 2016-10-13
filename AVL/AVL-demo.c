#include <stdio.h>
#include <stdlib.h>


#define LH  1 //左高
#define EH  0 //等高
#define RH -1 //右高
#define TRUE 1
#define FALSE 0


typedef int Status;
typedef char RcdType;

//定义平衡二叉树结构
typedef struct BBSTNode {
    RcdType data;
    int bf; //结点平衡因子
    struct BBSTNode *lchild, *rchild; //定义左右子树
} BBSTNode,*BBSTree;

// 凹入表打印
void zVisitAVL(BBSTree T, int num)
{
    int i;
    if (NULL == T)
    {
        return ;
    }

    zVisitAVL(T->rchild, num+5);
    for(i=0; i<num; i++)
    {
        printf(" ");
    }
    printf("%5c%d\n",T->data,T->bf);
    zVisitAVL(T->lchild,num+5);


}

//先序遍历平衡二叉树
void xVisitAVL(BBSTree T)
{
    if (NULL == T)
    {
        return ;
    }

    printf("%c ",T->data);
    xVisitAVL(T->lchild);
    xVisitAVL(T->rchild);
 }

//后序遍历平衡二叉树
void hVisitAVL(BBSTree T)
{
    if (NULL == T)
    {
        return ;
    }

    hVisitAVL(T->lchild);
    hVisitAVL(T->rchild);
    printf("%c ",T->data);
}

Status lVisitAVL(BBSTree T, Status depth) {
    if (!T || depth < 1)
    {
        printf(" ");
        return ;
    }

    if (1 == depth) {
        printf("%c", T->data);
        return TRUE;
    }
    return lVisitAVL(T->lchild, depth - 1) + lVisitAVL(T->rchild, depth - 1);
}

void printAVL(BBSTree T){
    if(NULL == T)
        return ;

    int i = 1,j,mark,depth = AVLDepth(T);
    mark = depth;
    for (i = 1; i<=depth; i++)
    {
        //printf("\n");
        if (!lVisitAVL(T, i))
            break;

    }
}

//查找RcdType节点
Status searchAVL(BBSTree T, RcdType data)
{
    if (!T)
        return FALSE;
    if (T->data == data)
        return TRUE;
    else if (data < T->data)
        return searchAVL(T->lchild, data);
    else
        return searchAVL(T->rchild, data);

}

// 销毁平衡二叉树
void destroyAVL(BBSTree *T)
{
    if(NULL == (*T))
        return ;

    destroyAVL(&((*T)->lchild));
    destroyAVL(&((*T)->rchild));
    *T = NULL;

}

// 计算二叉树深度
Status AVLDepth(BBSTree T)
{
    if(NULL == T)
        return 0;

    int left=1;
    int right=1;

    left += AVLDepth(T->lchild);
    right += AVLDepth(T->rchild);

    return left > right ? left : right;
}

//	左旋
void leftRotate(BBSTree *T)
{
	BBSTree rc = (*T)->rchild;
	(*T)->rchild = rc->lchild;
	rc->lchild = (*T);
	(*T) = rc;
}

//	右旋
void rightRotate(BBSTree *T)
{
	BBSTree lc = (*T)->lchild;
	(*T)->lchild = lc->rchild;
	lc->rchild = (*T);
	(*T) = lc;
}

//实现对树T的左平衡处理
void leftBalance(BBSTree *T)
{
	BBSTree lc = (*T)->lchild; //lc指向T的左孩子
    BBSTree rc;

	switch (lc->bf)
	{
	    //特殊情况, 删除时候要考虑EH, 否则会出现删除节点不平衡情况
	    case EH:
            (*T)->bf = LH;    rc->bf = EH;    rightRotate(T);
            break;

        //LL型, 进行右旋操作
        case LH:
            (*T)->bf = EH;  lc->bf = EH;    rightRotate(T);
            break;

        //LR型, 进行左旋操作, 再右旋操作
        case RH:
            rc = lc->rchild;
            switch (rc->bf) //修改T及其左孩子的平衡因子
            {
                case LH:    (*T)->bf = RH;  lc->bf = EH;    break;
                case EH:    (*T)->bf = EH;  lc->bf = EH;    break;
                case RH:    (*T)->bf = EH;  lc->bf = LH;    break;
            }

            rc->bf = EH;
            leftRotate(&((*T)->lchild));
            rightRotate(T);
            break;
        }
}

//实现对树T的右平衡处理
void rightBalance(BBSTree *T)
{
	BBSTree rc = (*T)->rchild;
    BBSTree lc;

	switch (rc->bf)
	{
	    //特殊情况, 删除时候要考虑EH, 否则会出现删除节点不平衡情况
        case EH:
            (*T)->bf = RH;    rc->bf = EH;    leftRotate(T);
            break;

		//RR型, 进行左旋操作
        case RH:
            (*T)->bf = EH;    rc->bf = EH;    leftRotate(T);
            break;

        //RL型, 进行右旋操作，再左旋操作
        case LH:
            lc = rc->lchild;

            switch (lc->bf)
            {
                case LH:    (*T)->bf = EH;    rc->bf = RH;    break;
                case EH:    (*T)->bf = EH;    rc->bf = EH;    break;
                case RH:    (*T)->bf = LH;    rc->bf = EH;    break;
            }

            lc->bf = EH;
            rightRotate(&((*T)->rchild));
            leftRotate(T);
            break;
	}
}

//实现对平衡二叉树的插入操作
Status insertAVL(BBSTree *T, RcdType data, Status *taller)
{
	if (NULL == *T) //T为空, 树长高
	{
        *T = (BBSTree)malloc(sizeof(BBSTNode));
		(*T)->rchild = (*T)->lchild = NULL;
		(*T)->data = data;
		(*T)->bf = EH;
		*taller = TRUE;
	}
	else
	{

		//树中已存在和data相等的结点
		if (data == (*T)->data)
		{
			*taller = FALSE;
			return FALSE;//未插入
		}
		//插入左子树
		else if (data < (*T)->data)
		{
			if (FALSE == insertAVL(&((*T)->lchild), data, taller)) //递归循环
			{
				return FALSE;//未插入
			}

            if (TRUE == *taller)
			{
				switch ((*T)->bf)// 检查T的平衡因子
				{
                    case LH://原左高, 左平衡
                        leftBalance(T);      *taller = FALSE;    break;
                    case EH://原等高, 左变高
                        (*T)->bf = LH;        *taller = TRUE;     break;
                    case RH://原右高, 变等高
                        (*T)->bf = EH;        *taller = FALSE;    break;
				}
			}


		}
		//插入右子树
		else
		{
			if (FALSE == insertAVL(&((*T)->rchild), data, taller))
			{
				return FALSE;//未插入
			}

			if (TRUE == *taller)
			{
				switch ((*T)->bf)
				{
                    case LH: //原左高, 变等高
                        (*T)->bf = EH;    *taller = FALSE;     break;
                    case EH: //原等高, 变右高
                        (*T)->bf = RH;    *taller = TRUE;      break;
                    case RH: //原右高, 右平衡
                        rightBalance(T); *taller = FALSE;     break;
				}
			}

		}
	}

	return TRUE;
}


//实现对平衡二叉树的删除操作
Status deleteAVL(BBSTree *T, RcdType data, Status *shorter)
{
    BBSTree q = NULL;

    if(NULL == (*T)) //空树
    {
        *shorter = FALSE;
        return FALSE;
    }


    else if(data == (*T)->data)
    {

        if(NULL == (*T)->lchild)    //左子树为空, 接右子树
        {
            (*T) = (*T)->rchild;
            *shorter = TRUE;
        }
        else if(NULL == (*T)->rchild)   //右子树为空, 接左子树
        {
            (*T) = (*T)->lchild;
            *shorter = TRUE;
        }
        else                            //左右子树均不空, 则用其左子树的最大值取代
        {
            q = (*T)->lchild;
            while(NULL != q->rchild)
            {
                q = q->rchild;
            }
            (*T)->data = q->data;
            deleteAVL(&((*T)->lchild), q->data, shorter);   //删除
            //(*T)->bf = AVLDepth((*T)->lchild) - AVLDepth((*T)->rchild);
            if(TRUE == *shorter)
            {
                switch((*T)->bf)
                {
                    case LH:
                        (*T)->bf = EH;
                        *shorter = TRUE;
                        break;
                    case EH:
                        (*T)->bf = AVLDepth((*T)->lchild) - AVLDepth((*T)->rchild);
                        *shorter = FALSE;
                        break;
                    case RH:
                        rightBalance(T);
                        if((*T)->rchild->bf == EH)
                            *shorter = FALSE;
                        else
                            *shorter = TRUE;
                        break;
                }
            }
        }
    }
    else if(data < (*T)->data)  //左子树中继续查找
    {
        if(FALSE == deleteAVL(&((*T)->lchild), data, shorter))
        {
            return FALSE;
        }
        if(TRUE == *shorter)
        {
            switch((*T)->bf)
            {
                case LH:
                    (*T)->bf = EH;
                    *shorter = TRUE;
                    break;
                case EH:
                    (*T)->bf = RH;
                    *shorter = FALSE;
                    break;
                case RH:
                    rightBalance(T);
                    if((*T)->rchild->bf == EH)
                        *shorter = FALSE;
                    else
                        *shorter = TRUE;
                    break;
            }
        }
    }
    else    //右子树中继续查找
    {
        if(FALSE == deleteAVL(&((*T)->rchild), data, shorter))
        {
            return FALSE;
        }
        if(TRUE == *shorter)
        {
            switch((*T)->bf)
            {
                case LH:
                    leftBalance(T);
                    if((*T)->lchild->bf == EH)
                        *shorter = FALSE;
                    else
                        *shorter = TRUE;

                    break;
                case EH:
                    (*T)->bf = LH;
                    *shorter = FALSE;
                    break;
                case RH:
                    (*T)->bf = EH;
                    *shorter = TRUE;
                    break;
            }
        }
    }
    return TRUE;
}


//合并两棵AVL
void mergeAVL(BBSTree *TA, BBSTree *TB)
{
    Status taller = FALSE;

    if(NULL == *TB)
    {
        return ;
    }

    mergeAVL(TA, &((*TB)->lchild));
    insertAVL(TA, (*TB)->data, &taller);
    mergeAVL(TA, &((*TB)->rchild));

}

Status splitAVL(BBSTree splitTree, BBSTree *tA, BBSTree *tB, RcdType data)
{
    Status taller = FALSE;

    if( NULL == splitTree)
    {
        return FALSE;
    }

    splitAVL(splitTree->lchild, tA ,tB ,data);

    if( data >= splitTree->data )
        insertAVL(tA, splitTree->data, &taller);
    else
        insertAVL(tB, splitTree->data, &taller);

    splitAVL(splitTree->rchild, tA ,tB ,data);

    return TRUE;
}

//菜单
void menu()
{
    system("cls");
    printf("\n\n\n");
    printf("************************主菜单*************************\n");
    printf("                     1:连续插入数据\n");
    printf("                     2:查找数据\n");
    printf("                     3:删除特定数据\n");
    printf("                     4:输出当前结果\n");
    printf("                     5:销毁当前AVL\n");
    printf("                     6:结束程序\n");
    printf("                     7:合并AVL\n");
    printf("                     8:分裂AVL\n");
    printf("\n");
    printf("*******************************************************");
}
void ABmenu()
{
    system("cls");
    printf("\n\n\n");
    printf("**********************选择主菜单***********************\n");
    printf("                        1:A树\n");
    printf("                        2:B树\n");
    printf("                        3:返回\n");
    printf("\n");
    printf("*******************************************************");
}

void main()
{
    /*
    //test
    BBSTree T,Tr,lT,rT;
    RcdType data = 'A';
    T  = (BBSTree)malloc(sizeof(BBSTNode));
    lT = (BBSTree)malloc(sizeof(BBSTNode));
    rT = (BBSTree)malloc(sizeof(BBSTNode));
    Tr = (BBSTree)malloc(sizeof(BBSTNode));
    T->data = 'F';
    lT->data = 'C';
    rT->data = 'D';
    Tr->data = 'G';

    T->lchild = lT;
    T->rchild = Tr;

    lT->lchild = NULL;
    lT->rchild = rT;
    rT->lchild = NULL;
    rT->rchild = NULL;
    Tr->lchild = NULL;
    Tr->rchild = NULL;

    T->bf = LH;
    lT->bf = RH;
    rT->bf = EH;
    Tr->bf = EH;

    Status taller = FALSE;

    xVisitAVL(T);
    printf("\n");
    zVisitAVL(T);
    printf("\n");
    hVisitAVL(T);
    printf("\n");
    insertAVL(&T, 'E', &taller);
    xVisitAVL(T);
    printf("\n");
    zVisitAVL(T);
    printf("\n");
    hVisitAVL(T);
    */



    int num,temp;
    RcdType data;
    BBSTree TA = NULL;
    BBSTree TB = NULL;
    BBSTree mergeT = NULL;
    Status taller = FALSE, shorter;
    system("color 0A");
    system("mode con: cols=55 lines=20");
    menu();

    while(1)
    {
        scanf("%d",&num);
        getchar();
        switch (num)
        {
            case 1:
                ABmenu();
                while(1)
                {
                    scanf("%d",&temp);
                    getchar();
                    system("cls");
                    switch(temp)
                    {
                        case 1:
                            system("cls");
                            printf("\n\n\n");
                            printf("\t\t请插入数据, 输入#结束插入\n");
                            printf("\n*******************************************************\n");

                            while(scanf("%c",&data))
                            {
                                if(data == '#')
                                    break;
                                else
                                {
                                    if(insertAVL(&TA, data, &taller))
                                        printf("\n\t\t\t%c 插入成功", data);
                                    else
                                        printf("\n\t\t\t%c 插入失败", data);
                                }

                            }
                            getchar();
                            printf("\n\n*******************************************************");

                            getchar();
                            ABmenu();

                            break;

                        case 2:
                            printf("\n\n\n");
                            printf("\t\t请插入数据, 输入#结束插入\n");
                            printf("\n*******************************************************\n");

                            while(scanf("%c",&data))
                            {
                                if(data == '#')
                                    break;
                                else
                                {
                                    if(insertAVL(&TB, data, &taller))
                                        printf("\n\t\t\t%c 插入成功", data);
                                    else
                                        printf("\n\t\t\t%c 插入失败", data);
                                }

                            }
                            getchar();
                            printf("\n\n*******************************************************");

                            getchar();
                            ABmenu();

                            break;

                        default:
                            ABmenu();
                            break;


                    }
                    if(temp == 3)
                    {
                        menu();
                        break;
                    }
                }

                break;

            case 2:
                ABmenu();
                while(1)
                {
                    scanf("%d",&temp);
                    getchar();
                    system("cls");
                    switch(temp)
                    {
                        case 1:
                            printf("\n\n\n\n");
                            printf("\t\t    请输入要查询的数\n");
                            printf("\n*******************************************************\n");

                            scanf("%c",&data);

                            printf("\n\n*******************************************************");
                            if (searchAVL(TA,data) == FALSE)
                            {
                                printf("\t\t     查找失败 %c!\n",data);
                            }
                            else
                            {
                                printf("\t\t     查找成功 %c!\n",data);
                            }

                            getchar();
                            getchar();
                            ABmenu();

                            break;

                        case 2:
                            printf("\n\n\n\n");
                            printf("\t\t    请输入要查询的数\n");
                            printf("\n*******************************************************\n");

                            scanf("%c",&data);

                            printf("\n\n*******************************************************");
                            if (searchAVL(TB,data) == FALSE)
                            {
                                printf("\t\t     查找失败 %c!\n",data);
                            }
                            else
                            {
                                printf("\t\t     查找成功 %c!\n",data);
                            }
                            getchar();
                            getchar();
                            ABmenu();
                            break;

                        default:
                            ABmenu();
                            break;
                    }
                    if(temp == 3)
                    {
                        menu();
                        break;
                    }
                }

                break;

            case 3:
                ABmenu();
                while(1)
                {
                    scanf("%d",&temp);
                    getchar();
                    system("cls");
                    switch(temp)
                    {
                        case 1:
                            printf("\n\n\n\n");
                            printf("\t\t 请输入要删除的数据\n");
                            printf("\n*******************************************************\n");

                            scanf("%c",&data);

                            printf("\n*******************************************************\n");

                            if(deleteAVL(&TA, data, &shorter))
                                printf("\n\t\t     删除成功");
                            else
                                printf("\n\t\t     删除失败");

                            getchar();
                            getchar();
                            ABmenu();

                            break;

                        case 2:
                            printf("\n\n\n\n");
                            printf("\t\t 请输入要删除的数据\n");
                            printf("\n*******************************************************\n");

                            scanf("%c",&data);

                            printf("\n*******************************************************\n");

                            if(deleteAVL(&TA, data, &shorter))
                                printf("\n\t\t     删除成功");
                            else
                                printf("\n\t\t     删除失败");

                            getchar();
                            getchar();
                            ABmenu();

                            break;

                        default:
                            ABmenu();
                            break;
                    }
                    if(temp == 3)
                    {
                        menu();
                        break;
                    }
                }

                break;

            case 4:
                ABmenu();
                while(1)
                {
                    scanf("%d",&temp);
                    getchar();
                    system("cls");
                    switch(temp)
                    {
                        case 1:
                            printf("凹形表达式输出 :\n\n");
                            zVisitAVL(TA, 0);

                            getchar();
                            ABmenu();
                            break;

                        case 2:
                            printf("凹形表达式输出 :\n\n");
                            zVisitAVL(TB, 0);

                            getchar();
                            ABmenu();

                            break;

                        default:
                            ABmenu();
                            break;
                    }
                    if(temp == 3)
                    {
                        menu();
                        break;
                    }
                }

                //printf("\n\n平衡二叉树的深度 : %d",AVLDepth(T));
                //printf("\n\n");
                //printAVL(T);

                break;

            case 5:
                ABmenu();
                while(1)
                {
                    scanf("%d",&temp);
                    getchar();
                    system("cls");
                    switch(temp)
                    {
                        case 1:
                            destroyAVL(&TA);

                            printf("\n\n\n\n\n");
                            printf("\n*******************************************************\n");
                            printf("\n\t\t\t删除成功\n\n");
                            printf("\n*******************************************************\n");

                            getchar();
                            ABmenu();

                            break;

                        case 2:
                            destroyAVL(&TB);

                            printf("\n\n\n\n\n");
                            printf("\n*******************************************************\n");
                            printf("\n\t\t\t删除成功\n\n");
                            printf("\n*******************************************************\n");
                            getchar();
                            ABmenu();

                            break;

                        default:
                            ABmenu();
                            break;
                    }
                    if(temp == 3)
                    {
                        menu();
                        break;
                    }
                }

                break;

            case 6:
                exit(0);

                break;

            case 7:
                system("cls");
                mergeAVL(&TA, &TB);

                printf("\n\n\n\n\n");
                printf("\n*******************************************************\n");

                printf("\n\t\t\t合并成功\n\n");

                printf("\n*******************************************************\n");

                getchar();
                menu();
                break;

            case 8:
                system("cls");
                BBSTree *tA = NULL;
                BBSTree *tB = NULL;

                printf("\n\n\n\n");
                printf("\t\t 请输入要分裂的数据\n");
                printf("\n*******************************************************\n");
                scanf("%c",&data);
                printf("\n*******************************************************\n");
                if(splitAVL(TA, &tA, &tB, data))
                    printf("\n\t\t     分裂成功");
                else
                    printf("\n\t\t     分裂失败");

                TA = tA;
                TB = tB;

                getchar();
                getchar();
                menu();
                break;

            default :
                menu();
                break;
            }
    }

}





