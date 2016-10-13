#include <stdio.h>
#include <stdlib.h>


#define LH  1 //���
#define EH  0 //�ȸ�
#define RH -1 //�Ҹ�
#define TRUE 1
#define FALSE 0


typedef int Status;
typedef char RcdType;

//����ƽ��������ṹ
typedef struct BBSTNode {
    RcdType data;
    int bf; //���ƽ������
    struct BBSTNode *lchild, *rchild; //������������
} BBSTNode,*BBSTree;

// ������ӡ
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

//�������ƽ�������
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

//�������ƽ�������
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

//����RcdType�ڵ�
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

// ����ƽ�������
void destroyAVL(BBSTree *T)
{
    if(NULL == (*T))
        return ;

    destroyAVL(&((*T)->lchild));
    destroyAVL(&((*T)->rchild));
    *T = NULL;

}

// ������������
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

//	����
void leftRotate(BBSTree *T)
{
	BBSTree rc = (*T)->rchild;
	(*T)->rchild = rc->lchild;
	rc->lchild = (*T);
	(*T) = rc;
}

//	����
void rightRotate(BBSTree *T)
{
	BBSTree lc = (*T)->lchild;
	(*T)->lchild = lc->rchild;
	lc->rchild = (*T);
	(*T) = lc;
}

//ʵ�ֶ���T����ƽ�⴦��
void leftBalance(BBSTree *T)
{
	BBSTree lc = (*T)->lchild; //lcָ��T������
    BBSTree rc;

	switch (lc->bf)
	{
	    //�������, ɾ��ʱ��Ҫ����EH, ��������ɾ���ڵ㲻ƽ�����
	    case EH:
            (*T)->bf = LH;    rc->bf = EH;    rightRotate(T);
            break;

        //LL��, ������������
        case LH:
            (*T)->bf = EH;  lc->bf = EH;    rightRotate(T);
            break;

        //LR��, ������������, ����������
        case RH:
            rc = lc->rchild;
            switch (rc->bf) //�޸�T�������ӵ�ƽ������
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

//ʵ�ֶ���T����ƽ�⴦��
void rightBalance(BBSTree *T)
{
	BBSTree rc = (*T)->rchild;
    BBSTree lc;

	switch (rc->bf)
	{
	    //�������, ɾ��ʱ��Ҫ����EH, ��������ɾ���ڵ㲻ƽ�����
        case EH:
            (*T)->bf = RH;    rc->bf = EH;    leftRotate(T);
            break;

		//RR��, ������������
        case RH:
            (*T)->bf = EH;    rc->bf = EH;    leftRotate(T);
            break;

        //RL��, ������������������������
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

//ʵ�ֶ�ƽ��������Ĳ������
Status insertAVL(BBSTree *T, RcdType data, Status *taller)
{
	if (NULL == *T) //TΪ��, ������
	{
        *T = (BBSTree)malloc(sizeof(BBSTNode));
		(*T)->rchild = (*T)->lchild = NULL;
		(*T)->data = data;
		(*T)->bf = EH;
		*taller = TRUE;
	}
	else
	{

		//�����Ѵ��ں�data��ȵĽ��
		if (data == (*T)->data)
		{
			*taller = FALSE;
			return FALSE;//δ����
		}
		//����������
		else if (data < (*T)->data)
		{
			if (FALSE == insertAVL(&((*T)->lchild), data, taller)) //�ݹ�ѭ��
			{
				return FALSE;//δ����
			}

            if (TRUE == *taller)
			{
				switch ((*T)->bf)// ���T��ƽ������
				{
                    case LH://ԭ���, ��ƽ��
                        leftBalance(T);      *taller = FALSE;    break;
                    case EH://ԭ�ȸ�, ����
                        (*T)->bf = LH;        *taller = TRUE;     break;
                    case RH://ԭ�Ҹ�, ��ȸ�
                        (*T)->bf = EH;        *taller = FALSE;    break;
				}
			}


		}
		//����������
		else
		{
			if (FALSE == insertAVL(&((*T)->rchild), data, taller))
			{
				return FALSE;//δ����
			}

			if (TRUE == *taller)
			{
				switch ((*T)->bf)
				{
                    case LH: //ԭ���, ��ȸ�
                        (*T)->bf = EH;    *taller = FALSE;     break;
                    case EH: //ԭ�ȸ�, ���Ҹ�
                        (*T)->bf = RH;    *taller = TRUE;      break;
                    case RH: //ԭ�Ҹ�, ��ƽ��
                        rightBalance(T); *taller = FALSE;     break;
				}
			}

		}
	}

	return TRUE;
}


//ʵ�ֶ�ƽ���������ɾ������
Status deleteAVL(BBSTree *T, RcdType data, Status *shorter)
{
    BBSTree q = NULL;

    if(NULL == (*T)) //����
    {
        *shorter = FALSE;
        return FALSE;
    }


    else if(data == (*T)->data)
    {

        if(NULL == (*T)->lchild)    //������Ϊ��, ��������
        {
            (*T) = (*T)->rchild;
            *shorter = TRUE;
        }
        else if(NULL == (*T)->rchild)   //������Ϊ��, ��������
        {
            (*T) = (*T)->lchild;
            *shorter = TRUE;
        }
        else                            //��������������, �����������������ֵȡ��
        {
            q = (*T)->lchild;
            while(NULL != q->rchild)
            {
                q = q->rchild;
            }
            (*T)->data = q->data;
            deleteAVL(&((*T)->lchild), q->data, shorter);   //ɾ��
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
    else if(data < (*T)->data)  //�������м�������
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
    else    //�������м�������
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


//�ϲ�����AVL
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

//�˵�
void menu()
{
    system("cls");
    printf("\n\n\n");
    printf("************************���˵�*************************\n");
    printf("                     1:������������\n");
    printf("                     2:��������\n");
    printf("                     3:ɾ���ض�����\n");
    printf("                     4:�����ǰ���\n");
    printf("                     5:���ٵ�ǰAVL\n");
    printf("                     6:��������\n");
    printf("                     7:�ϲ�AVL\n");
    printf("                     8:����AVL\n");
    printf("\n");
    printf("*******************************************************");
}
void ABmenu()
{
    system("cls");
    printf("\n\n\n");
    printf("**********************ѡ�����˵�***********************\n");
    printf("                        1:A��\n");
    printf("                        2:B��\n");
    printf("                        3:����\n");
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
                            printf("\t\t���������, ����#��������\n");
                            printf("\n*******************************************************\n");

                            while(scanf("%c",&data))
                            {
                                if(data == '#')
                                    break;
                                else
                                {
                                    if(insertAVL(&TA, data, &taller))
                                        printf("\n\t\t\t%c ����ɹ�", data);
                                    else
                                        printf("\n\t\t\t%c ����ʧ��", data);
                                }

                            }
                            getchar();
                            printf("\n\n*******************************************************");

                            getchar();
                            ABmenu();

                            break;

                        case 2:
                            printf("\n\n\n");
                            printf("\t\t���������, ����#��������\n");
                            printf("\n*******************************************************\n");

                            while(scanf("%c",&data))
                            {
                                if(data == '#')
                                    break;
                                else
                                {
                                    if(insertAVL(&TB, data, &taller))
                                        printf("\n\t\t\t%c ����ɹ�", data);
                                    else
                                        printf("\n\t\t\t%c ����ʧ��", data);
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
                            printf("\t\t    ������Ҫ��ѯ����\n");
                            printf("\n*******************************************************\n");

                            scanf("%c",&data);

                            printf("\n\n*******************************************************");
                            if (searchAVL(TA,data) == FALSE)
                            {
                                printf("\t\t     ����ʧ�� %c!\n",data);
                            }
                            else
                            {
                                printf("\t\t     ���ҳɹ� %c!\n",data);
                            }

                            getchar();
                            getchar();
                            ABmenu();

                            break;

                        case 2:
                            printf("\n\n\n\n");
                            printf("\t\t    ������Ҫ��ѯ����\n");
                            printf("\n*******************************************************\n");

                            scanf("%c",&data);

                            printf("\n\n*******************************************************");
                            if (searchAVL(TB,data) == FALSE)
                            {
                                printf("\t\t     ����ʧ�� %c!\n",data);
                            }
                            else
                            {
                                printf("\t\t     ���ҳɹ� %c!\n",data);
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
                            printf("\t\t ������Ҫɾ��������\n");
                            printf("\n*******************************************************\n");

                            scanf("%c",&data);

                            printf("\n*******************************************************\n");

                            if(deleteAVL(&TA, data, &shorter))
                                printf("\n\t\t     ɾ���ɹ�");
                            else
                                printf("\n\t\t     ɾ��ʧ��");

                            getchar();
                            getchar();
                            ABmenu();

                            break;

                        case 2:
                            printf("\n\n\n\n");
                            printf("\t\t ������Ҫɾ��������\n");
                            printf("\n*******************************************************\n");

                            scanf("%c",&data);

                            printf("\n*******************************************************\n");

                            if(deleteAVL(&TA, data, &shorter))
                                printf("\n\t\t     ɾ���ɹ�");
                            else
                                printf("\n\t\t     ɾ��ʧ��");

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
                            printf("���α��ʽ��� :\n\n");
                            zVisitAVL(TA, 0);

                            getchar();
                            ABmenu();
                            break;

                        case 2:
                            printf("���α��ʽ��� :\n\n");
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

                //printf("\n\nƽ������������ : %d",AVLDepth(T));
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
                            printf("\n\t\t\tɾ���ɹ�\n\n");
                            printf("\n*******************************************************\n");

                            getchar();
                            ABmenu();

                            break;

                        case 2:
                            destroyAVL(&TB);

                            printf("\n\n\n\n\n");
                            printf("\n*******************************************************\n");
                            printf("\n\t\t\tɾ���ɹ�\n\n");
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

                printf("\n\t\t\t�ϲ��ɹ�\n\n");

                printf("\n*******************************************************\n");

                getchar();
                menu();
                break;

            case 8:
                system("cls");
                BBSTree *tA = NULL;
                BBSTree *tB = NULL;

                printf("\n\n\n\n");
                printf("\t\t ������Ҫ���ѵ�����\n");
                printf("\n*******************************************************\n");
                scanf("%c",&data);
                printf("\n*******************************************************\n");
                if(splitAVL(TA, &tA, &tB, data))
                    printf("\n\t\t     ���ѳɹ�");
                else
                    printf("\n\t\t     ����ʧ��");

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





